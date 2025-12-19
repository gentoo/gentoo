# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Common files shared by Python implementations in Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Python"
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

src_install() {
	insinto /usr/lib/python
	# https://peps.python.org/pep-0668/
	newins - EXTERNALLY-MANAGED <<-EOF
		[externally-managed]
		Error=
		 The system-wide Python installation in Gentoo should be maintained
		 using the system package manager (e.g. emerge).

		 If the package in question is not packaged for Gentoo, please
		 consider installing it inside a virtual environment, e.g.:

		   python -m venv /path/to/venv
		   . /path/to/venv/bin/activate
		   pip install mypackage

		 To exit the virtual environment, run:

		   deactivate

		 The virtual environment is not deleted, and can be re-entered by
		 re-sourcing the activate file.
	EOF
}
