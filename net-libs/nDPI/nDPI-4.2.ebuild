# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Open Source Deep Packet Inspection Software Toolkit"
HOMEPAGE="https://www.ntop.org/"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ntop/${PN}"
	inherit git-r3
else
	SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-3+"
SLOT="0/$(ver_cut 1)"

DEPEND="dev-libs/json-c:=
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i \
		-e "s%^libdir\s*=\s*\${prefix}/lib\s*$%libdir     = \${prefix}/$(get_libdir)%" \
		src/lib/Makefile.in || die

	eautoreconf
}

src_test() {
	pushd tests || die

	./do.sh || die "Failed tests"
	./do-unit.sh || die "Failed unit tests"

	popd || die
}

src_install() {
	default

	rm "${ED}/usr/$(get_libdir)"/lib${PN,,}.a || die
}
