# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An OCI container runtime monitor"
HOMEPAGE="https://github.com/containers/conmon"
SRC_URI="https://github.com/containers/conmon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"
IUSE="systemd"
RESTRICT="test"

RDEPEND="dev-libs/glib:=
	systemd? ( sys-apps/systemd:= )"
DEPEND="${RDEPEND}
	dev-go/go-md2man"

src_prepare() {
	default

	if ! use systemd; then
		sed -e 's| $(PKG_CONFIG) --exists libsystemd-journal | false |' \
			-e 's| $(PKG_CONFIG) --exists libsystemd | false |' \
			-i Makefile || die
	fi
	sed -e 's|make -C tools|$(MAKE) -C tools|' -i Makefile || die
	sed -e 's|^GOMD2MAN = .*|GOMD2MAN = go-md2man|' -i docs/Makefile || die
}

src_compile() {
	tc-export CC
	emake GIT_COMMIT="v${PV}" \
		all
}

src_install() {
	emake DESTDIR="${D}" \
		PREFIX="/usr" \
		install
	dodir /usr/libexec/podman
	ln "${ED}/usr/"{bin,libexec/podman}/conmon || die
	dodoc README.md
}
