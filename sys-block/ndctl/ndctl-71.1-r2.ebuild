# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

DESCRIPTION="Helper tools and libraries for managing non-volatile memory on Linux"
HOMEPAGE="https://github.com/pmem/ndctl"
SRC_URI="https://github.com/pmem/ndctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MIT CC0-1.0"
SLOT="0/6"
KEYWORDS="amd64 ~x86"
IUSE="systemd test"

DEPEND="
	dev-libs/json-c:=
	sys-apps/keyutils:=
	sys-apps/kmod:=
	sys-apps/util-linux:=
	virtual/libudev:=
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	dev-build/libtool
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

# tests require root access
RESTRICT+=" test"

DOCS=(
	README.md
	CONTRIBUTING.md
)

PATCHES=(
	"${FILESDIR}/${PN}-71.1-bash-completion-configure.patch"
)

src_prepare() {
	default
	printf 'm4_define([GIT_VERSION], [%s])' "${PV}" > version.m4 || die
	sed -e '/git-version-gen/ d' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--with-bash-completion-dir="$(get_bashcompdir)" \
		$(use_with systemd) \
		--disable-asciidoctor
}

src_test() {
	emake check
}

src_install() {
	default

	bashcomp_alias ndctl daxctl
}
