# network-forensics-labs

A growing collection of hands-on network forensics labs built for teaching, learning, and experimentation.

## Project Status

This repository is actively maintained.

- Existing labs will continue to be improved over time.
- New labs will be added incrementally.
- Documentation and setup scripts will be refined as labs evolve.

## Current Labs

### `netforlab-2lan-kathara`

A Kathara-based two-LAN forensics lab with DNS, HTTP, FTP, router/switch segments, traffic mirroring, and analysis workflows.

See:

- [`netforlab-2lan-kathara/README.md`](netforlab-2lan-kathara/README.md)
- [`netforlab-2lan-kathara/EXPERIMENTS.md`](netforlab-2lan-kathara/EXPERIMENTS.md)

## Roadmap

Planned direction for this repository:

- Expand the lab catalog with additional network-forensics scenarios.
- Cover different protocols, attack patterns, and investigation workflows.
- Keep labs reproducible with clear setup and dependency scripts.

## Contributing

Contributions are welcome.

When adding or updating a lab:

- Keep setup steps explicit and reproducible.
- Document topology, services, and learning objectives.
- Include safe-use notes for authorized environments.
- Prefer small, focused pull requests.

## Lab Template

Use this structure as a baseline for new labs:

```text
<lab-name>/
	README.md                  # overview, prerequisites, startup, access
	EXPERIMENTS.md             # guided activities and expected outcomes
	lab.conf                   # topology definition
	*.startup                  # per-node startup scripts
	scripts/
		install_lab_dependencies.sh
		setup_python_venv.sh     # if Python tooling is required
	dockerfiles/               # custom images (if needed)
```

Recommended minimum content for each lab README:

- Learning goals
- Topology summary
- Requirements and installation
- Start/stop workflow
- Access methods (CLI/web/VNC)
- Suggested exercises

## Audience

This repository is intended for:

- Cybersecurity students
- Instructors and lab developers
- Practitioners exploring packet-level investigations

## Notes

Use these labs only in authorized and isolated environments.
