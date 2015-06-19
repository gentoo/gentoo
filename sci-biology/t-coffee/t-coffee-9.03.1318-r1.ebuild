# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/t-coffee/t-coffee-9.03.1318-r1.ebuild,v 1.6 2015/04/26 16:59:53 pacho Exp $

EAPI=5

inherit eutils flag-o-matic fortran-2 toolchain-funcs versionator

MY_PV="$(replace_version_separator 2 .r)"
MY_P="T-COFFEE_distribution_Version_${MY_PV}"

DESCRIPTION="A multiple sequence alignment package"
HOMEPAGE="http://www.tcoffee.org/Projects_home_page/t_coffee_home_page.html"
SRC_URI="http://www.tcoffee.org/Packages/Stable/Version_${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	sci-biology/clustalw
	sci-chemistry/tm-align"
DEPEND=""

S="${WORKDIR}/${MY_P}"

die_compile() {
	echo
	eerror "If you experience an internal compiler error (consult the above"
	eerror "messages), try compiling t-coffee using very modest compiler flags."
	eerror "See bug #114745 on the Gentoo Bugzilla for more details."
	die "Compilation failed"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
}

src_compile() {
	[[ $(gcc-version) == "3.4" ]] || \
		[[ $(gcc-version) == "4.1" ]] && \
		append-flags -fno-unit-at-a-time
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		-C t_coffee_source t_coffee
}

src_install() {
	dobin t_coffee_source/t_coffee

	if use examples; then
		insinto /usr/share/${PN}
		doins -r example
	fi
}
