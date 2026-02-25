import matplotlib.pyplot as plt
import networkx as nx
from pathlib import Path


def build_graph() -> nx.Graph:
    graph = nx.Graph()

    graph.add_node("r1", role="router", label="r1 (router)")

    for node in ["dns1", "ftp1", "web1", "nspc1", "pc1", "pc2", "web2", "nspc2", "pc3"]:
        graph.add_node(node, role="host", label=node)

    graph.add_node("wiresharka", role="sniffer", label="wiresharka")
    graph.add_node("wiresharkb", role="sniffer", label="wiresharkb")

    graph.add_node("s1", role="switch", label="s1\nOVS")
    graph.add_node("s2", role="switch", label="s2\nOVS")

    graph.add_edge("r1", "s1", label="eth0")
    graph.add_edge("r1", "s2", label="eth1")

    for node in ["dns1", "ftp1", "web1", "nspc1", "pc1", "pc2", "wiresharka"]:
        graph.add_edge("s1", node, label="eth0")

    for node in ["web2", "nspc2", "pc3", "wiresharkb"]:
        graph.add_edge("s2", node, label="eth0")

    return graph


def build_positions() -> dict[str, tuple[float, float]]:
    pos = {
        "s1": (-1.0, 0.0),
        "r1": (0.0, 0.0),
        "s2": (1.0, 0.0),
        "dns1": (-1.6, -1.5),
        "ftp1": (-1.6, -1.0),
        "web1": (-1.6, -0.5),
        "nspc1": (-1.6, 0.5),
        "pc1": (-1.6, 1.0),
        "pc2": (-1.6, 1.5),
        "wiresharka": (-1.6, 2.0),
        "web2": (1.6, -0.5),
        "nspc2": (1.6, 0.5),
        "pc3": (1.6, 1.0),
        "wiresharkb": (1.6, 1.5),
    }

    return pos


def draw_graph(graph: nx.Graph, pos: dict[str, tuple[float, float]]) -> None:
    plt.figure(figsize=(12, 6))

    roles = {node: graph.nodes[node]["role"] for node in graph.nodes}

    host_nodes = [n for n, r in roles.items() if r == "host"]
    router_nodes = [n for n, r in roles.items() if r == "router"]
    switch_nodes = [n for n, r in roles.items() if r == "switch"]
    sniffer_nodes = [n for n, r in roles.items() if r == "sniffer"]

    nx.draw_networkx_nodes(
        graph,
        pos,
        nodelist=host_nodes,
        node_color="#d3d3d3",
        node_shape="s",
        node_size=2200,
    )
    nx.draw_networkx_nodes(
        graph,
        pos,
        nodelist=router_nodes,
        node_color="#d3d3d3",
        node_shape="s",
        node_size=2400,
    )
    nx.draw_networkx_nodes(
        graph,
        pos,
        nodelist=sniffer_nodes,
        node_color="#d3d3d3",
        node_shape="s",
        node_size=2200,
    )
    nx.draw_networkx_nodes(
        graph,
        pos,
        nodelist=switch_nodes,
        node_color="#b7e0f0",
        node_shape="o",
        node_size=2000,
    )

    nx.draw_networkx_edges(graph, pos, width=1.2)

    labels = {n: graph.nodes[n]["label"] for n in graph.nodes}
    nx.draw_networkx_labels(graph, pos, labels=labels, font_size=9)

    edge_labels = {edge: graph.edges[edge]["label"] for edge in graph.edges}
    nx.draw_networkx_edge_labels(graph, pos, edge_labels=edge_labels, font_size=8)

    plt.axis("off")
    plt.tight_layout()


if __name__ == "__main__":
    g = build_graph()
    positions = build_positions()
    draw_graph(g, positions)
    lab_dir = Path(__file__).resolve().parent.parent
    plt.savefig(lab_dir / "network-diagram.png", dpi=200)
    plt.savefig(lab_dir / "network-diagram.svg")
