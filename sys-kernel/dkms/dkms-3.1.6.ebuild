# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info optfeature

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dell/dkms"
else
	SRC_URI="https://github.com/dell/dkms/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 x86"
fi

DESCRIPTION="Dynamic Kernel Module Support"
HOMEPAGE="https://github.com/dell/dkms"

LICENSE="GPL-2"
SLOT="0"
IUSE="systemd"
RESTRICT="test" # Should be run in a container

RDEPEND="
	sys-apps/kmod
	virtual/linux-sources
	systemd? ( sys-apps/systemd )
"

CONFIG_CHECK="~MODULES"

src_compile() {
	emake KCONF="/usr/lib/kernel"
}

src_test() {
	chmod +x dkms run_test.sh || die
	PATH="${PATH}:$(pwd)" ./run_test.sh || die "Tests failed"
}

src_install() {
	if use systemd; then
		emake install-redhat DESTDIR="${ED}" KCONF="/usr/lib/kernel"
	else
		emake install-debian DESTDIR="${ED}" KCONF="/usr/lib/kernel"
	fi

	einstalldocs
	keepdir /var/lib/dkms
}

pkg_postinst() {
	optfeature "automatically running \"dkms autoinstall\" on each kernel installation" \
		sys-kernel/installkernel
}
