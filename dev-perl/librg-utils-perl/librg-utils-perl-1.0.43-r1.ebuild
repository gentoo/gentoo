# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="Parsers and format conversion utilities used by (e.g.) profphd"
HOMEPAGE="http://rostlab.org/"
SRC_URI="ftp://rostlab.org/librg-utils-perl/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-perl/List-MoreUtils"
DEPEND="${RDEPEND}
	sci-libs/profphd-utils
	dev-perl/Module-Build
"
PATCHES=("${FILESDIR}/${P}-defined-array.patch")
src_configure() {
	econf
	perl-module_src_configure
}

src_install() {
	rm mat/Makefile* || die
	perl-module_src_install
	insinto /usr/share/${PN}
	doins -r mat
	exeinto /usr/share/${PN}
	doexe *.pl dbSwiss
	doman blib/libdoc/*
}
src_test() {
	local MODULES=(
		"RG::Utils::Conv_hssp2saf"
		"RG::Utils::Hssp_filter"
		"RG::Utils::Copf"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	perl-module_src_test
}
