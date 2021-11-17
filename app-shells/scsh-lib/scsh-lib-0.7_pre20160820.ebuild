# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# compatible scheme48 version
SCHEME48V="1.9.2"

inherit autotools

SCSH_HASH="114432435e4eadd54334df6b37fcae505079b49f"
RX_HASH="d3231ad13de2b44e3ee173b1c9d09ff165e8b6d5"

DESCRIPTION="Unix shell embedded in Scheme (libraries and launcher)"
HOMEPAGE="https://www.scsh.net/"
SRC_URI="
	https://github.com/scheme/scsh/archive/${SCSH_HASH}.tar.gz -> scsh-${PV}.tar.gz
	https://github.com/scheme/rx/archive/${RX_HASH}.tar.gz -> scsh-${PV}_rx.tar.gz
"
S="${WORKDIR}/scsh-${SCSH_HASH}"

RESTRICT="test"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# older versions were in conflict with scheme48's files, 2016 version uses them
DEPEND="
	~dev-scheme/scheme48-${SCHEME48V}
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/Makefile.in-LDFLAGS.patch" )

src_unpack() {
	unpack scsh-${PV}.tar.gz

	tar xf "${DISTDIR}/scsh-${PV}_rx.tar.gz" --strip-components 1 -C "${S}/rx/" ||
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
	emake DESTDIR="${D}" SCHEME48VM=${SCHEME48VM} enough dirs install-scsh
}
