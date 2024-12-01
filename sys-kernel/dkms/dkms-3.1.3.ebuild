# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info optfeature

DESCRIPTION="Dynamic Kernel Module Support"
HOMEPAGE="https://github.com/dell/dkms"
SRC_URI="https://github.com/dell/dkms/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="systemd"

RDEPEND="
	sys-apps/kmod
	virtual/linux-sources
	systemd? ( sys-apps/systemd )
"

# Cannot work in the emerge sandbox
RESTRICT="test"

CONFIG_CHECK="~MODULES"

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

pkg_postinst() {
	optfeature "automatically running \"dkms autoinstall\" on each kernel installation" \
		sys-kernel/installkernel
}
