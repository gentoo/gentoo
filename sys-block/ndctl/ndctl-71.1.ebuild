# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

DESCRIPTION="Helper tools and libraries for managing non-volatile memory on Linux"
HOMEPAGE="https://github.com/pmem/ndctl"
SRC_URI="https://github.com/pmem/ndctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MIT CC0-1.0"
SLOT="0/6"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion systemd test"

DEPEND="
	sys-apps/kmod:=
	virtual/libudev:=
	sys-apps/util-linux:=
	dev-libs/json-c:=
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	sys-devel/libtool
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

# tests require root access
RESTRICT+=" test"

DOCS=(
	README.md
	CONTRIBUTING.md
)

src_prepare() {
	default
	printf 'm4_define([GIT_VERSION], [%s])' "${PV}" > version.m4 || die
	sed -e '/git-version-gen/ d' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_with bash-completion bash) \
		$(use_with systemd) \
		--disable-asciidoctor
}

src_test() {
	emake check
}

src_install() {
	default

	use bash-completion && bashcomp_alias ndctl daxctl
}
