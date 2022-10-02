# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A ZNC module which provides client specific buffers"
HOMEPAGE="https://github.com/CyberShadow/znc-clientbuffer"
SRC_URI="https://github.com/CyberShadow/znc-clientbuffer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-irc/znc:="

RDEPEND="${DEPEND}"

DOCS=( README.md )

_emake() {
	emake \
		-j1 \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR=/$(get_libdir) \
		"$@"
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${ED}" install

	einstalldocs
}
