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
	SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-patches.tar.bz2"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-3+"
SLOT="0/$(ver_cut 1)"

DEPEND="dev-libs/json-c:=
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error
	net-libs/libpcap"
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}"/${P}-patches/
)

# Also sent a patch upstream https://github.com/ntop/nDPI/pull/1392 for
# AR/CC etc but doesn't apply cleanly (at all) to 4.0.

src_prepare() {
	default

	sed -i \
		-e "s%^libdir\s*=\s*\${prefix}/lib\s*$%libdir     = \${prefix}/$(get_libdir)%" \
		src/lib/Makefile.in || die

	eautoreconf

	# Should be able to drop in next version.
	# Taken from autogen.sh (bug #704074):
	sed -i \
		-e "s/#define PACKAGE/#define NDPI_PACKAGE/g" \
		-e "s/#define VERSION/#define NDPI_VERSION/g" \
		configure || die
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
