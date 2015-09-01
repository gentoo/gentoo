# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit fortran-2 python-single-r1 toolchain-funcs

MY_PN="pdbTools"

DESCRIPTION="Tools for manipulating and doing calculations on wwPDB macromolecule structure files"
HOMEPAGE="https://github.com/harmslab/pdbtools"
SRC_URI="https://${PN}.googlecode.com/files/${MY_PN}_${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_PN}_${PV}

pkg_setup() {
	python-single-r1_pkg_setup
	fortran-2_pkg_setup
}

src_prepare() {
	sed \
		-e "s:script_dir,\"pdb_data\":\"${EPREFIX}/usr/share/${PN}\",\"pdb_data\":g" \
		-i pdb_sasa.py || die
	sed \
		-e "/satk_path =/s:^.*$:satk_path = \"${EPREFIX}/usr/bin\":g" \
		-i pdb_satk.py || die
	sed \
		-e 's:> %:>%:g' \
		-i pdb_seq.py || die

	sed \
		-e "/import/s:helper:${PN/-/_}.helper:g" \
		-i *.py || die
}

src_compile() {
	mkdir bin
	cd satk
	for i in *.f; do
		einfo "$(tc-getFC) ${FFLAGS} ${LDFLAGS} ${i} -o ${i/.f}"
		$(tc-getFC) ${FFLAGS} -c ${i} -o ${i/.f/.o} || die
		$(tc-getFC) ${LDFLAGS} -o ../bin/${i/.f} ${i/.f/.o} || die
		sed \
			-e "s:${i/.f}.out:${i/.f}:g" \
			-i ../pdb_satk.py || die
	done
}

src_install() {
	local script
	insinto /usr/share/${PN}
	doins -r pdb_data/peptides
	rm -rf pdb_data/peptides || die

	python_domodule pdb_data

	python_moduleinto ${PN/-/_}
	python_domodule helper *.py

	for i in pdb_*.py; do
		cat > ${i/.py} <<- EOF
		#!${EPREFIX}/bin/bash
		${PYTHON} -O "$(python_get_sitedir)/${PN/-/_}/${i}" \$@
		EOF
		dobin ${i/.py}
	done

	dobin bin/*
	dodoc README
}
