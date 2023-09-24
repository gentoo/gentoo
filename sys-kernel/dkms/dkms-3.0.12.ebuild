# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

DESCRIPTION="Dynamic Kernel Module Support"
HOMEPAGE="https://github.com/dell/dkms"
SRC_URI="https://github.com/dell/dkms/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="systemd"

CONFIG_CHECK="~MODULES"

RDEPEND="
	sys-apps/kmod
	virtual/linux-sources
	systemd? ( sys-apps/systemd )
"

PATCHES=(
	"${FILESDIR}/${P}-add-gentoo-os-id.patch"
)

# Can not work in the emerge sandbox
RESTRICT="test"

src_compile() {
	# Nothing to do here
	return
}

src_test() {
	chmod +x dkms || die
	PATH="${PATH}:$(pwd)" ./run_test.sh || die "Tests failed"
}

src_install() {
	if use systemd; then
		emake install-redhat DESTDIR="${ED}" KCONF="/usr/lib/kernel"
	else
		emake install DESTDIR="${ED}" KCONF="/usr/lib/kernel"
	fi
	einstalldocs
	keepdir /var/lib/dkms
}
