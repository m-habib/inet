//
// Copyright (C) 2004 Andras Varga
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//




package inet.examples.inet.realEctNet;

import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import ned.DatarateChannel;
import inet.visualizer.integrated.IntegratedVisualizer;
import inet.node.ethernet.Eth100G;
import inet.node.ethernet.Eth100M;
import inet.node.ethernet.Eth10M;


network EctNet
{
    types:
        channel ethernetline extends DatarateChannel
        {
            delay = 0.1us;
            datarate = 100Mbps;
        }
        channel gigabitline extends DatarateChannel
        {
            delay = 0.1us;
            datarate = 1Gbps;
        }

    submodules:
        configurator: IPv4NetworkConfigurator {
            @display("p=25,61");
        }
        cli_NSSL[4]: StandardHost {
            parameters:
                @display("i=device/laptop_s");
        }

        cli_Technion_TCE[3]: StandardHost;
        cli_MIT_TCE[3]: StandardHost;
        cli_VLSIa[4]: StandardHost {
            parameters:
                @display("i=device/laptop_s");
        }
        cli_VLSIb[4]: StandardHost {
            parameters:
                @display("i=device/laptop_s");
        }

        rte_VLSI[2]: Router {
            parameters:
                @display("is=vs");
        }

        rte_faculty[6]: Router {
            parameters:
                @display("is=vs");
        }

        rte_faculty_out_1: Router {
            parameters:
                @display("p=487,61");
        }

        rte_public[1]: Router {
            parameters:
                @display("is=vs");
        }

        rte_MIT_TCE: Router {
            parameters:
                @display("is=vs");
        }

        amazon_srv: StandardHost {
            parameters:
                @display("i=device/server_s;p=574,31");
        }

        google_srv: StandardHost {
            parameters:
                @display("i=device/server_s;p=522,14");
        }

        visualizer: IntegratedVisualizer {
            @display("p=25,22");
        }

    connections:
        for i=0..sizeof(cli_NSSL)-1 {
            cli_NSSL[i].pppg++ <--> ethernetline <--> rte_faculty[0].pppg++;
        }
        for i=0..sizeof(cli_Technion_TCE)-1 {
            cli_Technion_TCE[i].pppg++ <--> ethernetline <--> rte_faculty[1].pppg++;
        }


        for i=0..sizeof(cli_MIT_TCE)-1 {
            cli_MIT_TCE[i].pppg++ <--> ethernetline <--> rte_MIT_TCE.pppg++;
        }
        for i=0..sizeof(cli_VLSIa)-1 {
            cli_VLSIa[i].pppg++ <--> ethernetline <--> rte_VLSI[0].pppg++;
        }
        for i=0..sizeof(cli_VLSIb)-1 {
            cli_VLSIb[i].pppg++ <--> ethernetline <--> rte_VLSI[1].pppg++;
        }

        rte_VLSI[0].pppg++ <--> Eth100M <--> rte_faculty[2].pppg++;
        rte_VLSI[1].pppg++ <--> Eth100M <--> rte_faculty[2].pppg++;
        rte_faculty[0].pppg++ <--> Eth100M <--> rte_faculty[3].pppg++;
        rte_faculty[1].pppg++ <--> Eth100M <--> rte_faculty[3].pppg++;
        rte_faculty[5].pppg++ <--> Eth100M <--> rte_faculty_out_1.pppg++;
        rte_faculty[2].pppg++ <--> Eth100M <--> rte_faculty_out_1.pppg++;


        rte_faculty[1].pppg++ <--> ethernetline <--> rte_public[0].pppg++;
        rte_public[0].pppg++ <--> ethernetline <--> rte_MIT_TCE.pppg++;

        rte_faculty[2].pppg++ <--> Eth100M <--> rte_faculty[4].pppg++;
        rte_faculty[4].pppg++ <--> Eth100M <--> rte_faculty[5].pppg++;
        rte_faculty[5].pppg++ <--> Eth100M <--> rte_faculty[3].pppg++;

        rte_faculty_out_1.pppg++ <--> Eth100M <--> amazon_srv.pppg++;
        rte_faculty_out_1.pppg++ <--> Eth100M <--> google_srv.pppg++;

}