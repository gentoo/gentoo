# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_cut 1-2)

# For snapshots: keep the hashes in sync with dev-scheme/scsh-lib
SCSH_H=114432435e4eadd54334df6b37fcae505079b49f
RX_H=d3231ad13de2b44e3ee173b1c9d09ff165e8b6d5

# compatible scheme48 version
SCHEME48V=1.9.2

inherit autotools

DESCRIPTION="Unix shell embedded in Scheme"
HOMEPAGE="https://www.scsh.net/"
SRC_URI="
	https://github.com/scheme/scsh/archive/${SCSH_H}.tar.gz -> ${P}.tar.gz
	https://github.com/scheme/rx/archive/${RX_H}.tar.gz -> ${P}_rx.tar.gz
"
S="${WORKDIR}/scsh-${SCSH_H}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# older versions were in conflict with scheme48's files, on the other hand,
# new 2016 version uses scheme48
RDEPEND="~dev-scheme/scsh-lib-${PV}"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/scsh-${MY_PV}-Makefile.in-LDFLAGS.patch
	"${FILESDIR}"/scsh-${MY_PV}-test-packages.patch
)

src_unpack() {
	unpack ${P}.tar.gz

	tar xf "${DISTDIR}/${P}_rx.tar.gz" --strip-components 1 -C "${S}/rx/" ||
		die "Failed to unpack ${P}_rx.tar.gz"
}

src_prepare() {
	SCHEME48VM=/usr/$(get_libdir)/scheme48-${SCHEME48V}/scheme48vm
	export SCHEME48VM

	default
	eautoreconf
}

src_configure() {
	econf --with-scheme48=${SCHEME48VM}
}

src_compile() {
	emake SCHEME48VM=${SCHEME48VM}
}

src_install() {
	emake SCHEME48VM=${SCHEME48VM} DESTDIR="${T}/install" \
		  enough dirs install-scsh install-scsh-image

	dobin "${T}"/install/usr/bin/scsh
	insinto /usr/$(get_libdir)/scsh-${MY_PV}/
	doins "${T}"/install/usr/$(get_libdir)/scsh-${MY_PV}/scsh.image
}
