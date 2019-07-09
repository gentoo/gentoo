# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
DESCRIPTION="An OCI container runtime monitor"
HOMEPAGE="https://github.com/containers/conmon"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="systemd"
EGIT_COMMIT="59952292a3b07ac125575024ae21956efe0ecdfb"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RDEPEND="dev-libs/glib:=
	systemd? ( sys-apps/systemd:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	if ! use systemd; then
		sed -e 's| pkg-config --exists libsystemd-journal | false |' \
			-e 's| pkg-config --exists libsystemd | false |' \
			-i Makefile || die
	fi
}

src_compile() {
	emake GIT_COMMIT="${EGIT_COMMIT}" \
		all
}

src_install() {
	emake DESTDIR="${D}" \
		PREFIX="${ED}/usr" \
		install
	mv "${ED}/usr/libexec"/{crio,podman} || die
	dodir /usr/bin
	ln "${ED}/usr/"{libexec/podman,bin}/conmon || die
	dodoc README.md
}
