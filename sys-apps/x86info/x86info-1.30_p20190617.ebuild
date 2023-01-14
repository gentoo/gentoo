# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit flag-o-matic linux-info python-any-r1 toolchain-funcs

# Upstream stopped versioned releases entirely
COMMIT="8ea5ed19fae1d209eba9257171a10f7afd474618"

DESCRIPTION="Dave Jones' handy, informative x86 CPU diagnostic utility"
HOMEPAGE="http://www.codemonkey.org.uk/projects/x86info/"
SRC_URI="https://github.com/kernelslacker/x86info/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 x86"

RDEPEND="sys-apps/pciutils:="
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.30-pic.patch #270388
	"${FILESDIR}"/${PN}-1.30-makefile.patch
)

pkg_setup() {
	CONFIG_CHECK="~MTRR ~X86_CPUID"
	linux-info_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# These flags taken from the 1.29 ebuild
	append-flags -Wall -Wshadow -Wextra -Wmissing-declarations \
		-Wdeclaration-after-statement -Wredundant-decls
	append-ldflags -Wl,-z,relro,-z,now

	tc-export CC PKG_CONFIG
}

src_compile() {
	emake x86info
}

src_install() {
	dobin x86info

	insinto /etc/modprobe.d
	newins "${FILESDIR}"/x86info-modules.conf-rc x86info.conf

	einstalldocs
	doman x86info.1
}

pkg_preinst() {
	if [[ -a "${EROOT}"/etc/modules.d/x86info ]] && [[ ! -a "${EROOT}"/etc/modprobe.d/x86info ]]; then
		elog "Moving x86info from /etc/modules.d/ to /etc/modprobe.d/"
		mv "${EROOT}"/etc/{modules,modprobe}.d/x86info
	fi
	if [[ -a "${EROOT}"/etc/modprobe.d/x86info ]] && [[ ! -a "${EROOT}"/etc/modprobe.d/x86info.conf ]]; then
		elog "Adding .conf suffix to x86info in /etc/modprobe.d/"
		mv "${EROOT}"/etc/modprobe.d/x86info{,.conf}
	fi
}
