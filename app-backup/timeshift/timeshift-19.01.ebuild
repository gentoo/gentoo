# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.40"
inherit vala

DESCRIPTION="A system restore utility for Linux"
HOMEPAGE="https://github.com/teejee2008/timeshift"
SRC_URI="https://github.com/teejee2008/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=x11-libs/gtk+-3.24.8
	>=net-libs/libsoup-2.64.2
	dev-util/desktop-file-utils
	net-misc/rsync
	dev-libs/json-glib
	sys-process/cronie
	>=x11-libs/xapps-1.4.2
	>=dev-libs/libgee-0.20.1
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-lang/vala-0.40.14
	sys-apps/diffutils
	sys-apps/coreutils
	>=x11-libs/vte-0.54.4[vala]
"

src_prepare() {
	sed -e 's:--thread:& Core/AppExcludeEntry.vala:' -i 'src/makefile'
	mkdir ${S}/tmpbin
	ln -s $(echo $(whereis valac-) | grep -oE "[^[[:space:]]*$") ${S}/tmpbin/valac
	vala_src_prepare
	default
}

src_configure() {
	PATH="${S}/tmpbin/:$PATH"
}
