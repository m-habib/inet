package inet.examples.inet.simulation1;

import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import ned.DatarateChannel;
import inet.visualizer.integrated.IntegratedVisualizer;
import inet.node.ethernet.Eth100M;
import inet.node.ethernet.Eth10M;
import inet.common.queue.FIFOQueue;
import inet.common.queue.IOutputQueue;
import inet.common.queue.REDDropper;

module REDQueue like IOutputQueue
{
    gates:
        input in;
        output out;

    submodules:
        red: REDDropper {
            numGates = 1;
            wq = default(0.002);
            minths = default("60");
            maxths = default("80");
            maxps = default("0.10");
            pkrates = default("8333.333");
        }
        fifo: FIFOQueue;
    connections:
        in --> red.in[0];
        red.out[0] --> fifo.in++;
        fifo.out --> out;
}

network Simulation1
{
    submodules:
        configurator: IPv4NetworkConfigurator;
        
        server: StandardHost {
            parameters:
                @display("i=device/server_s;p=20,250");
        }

        R1: Router {
            parameters:
                @display("is=vs;p=100,250");
        }
        
        R2: Router {
            parameters:
                @display("is=vs;p=180,250");
        }
        
        Host1: StandardHost {
            parameters:
                @display("i=device/laptop_s;p=280,200");
        }
        
        Host2: StandardHost {
            parameters:
                @display("i=device/laptop_s;p=280,300");
        }
        
        visualizer: IntegratedVisualizer {
            @display("");
        }

    connections:
        server.pppg++ <--> Eth100M <--> R1.pppg++;
        R1.pppg++ <--> Eth10M { @display("ls=blue,3;t=bottleneck"); }<--> R2.pppg++;
        R2.pppg++ <--> Eth100M <--> Host1.pppg++;
        R2.pppg++ <--> Eth100M <--> Host2.pppg++;
}
