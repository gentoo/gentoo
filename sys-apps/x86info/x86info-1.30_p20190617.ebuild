# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4..8} )

inherit flag-o-matic linux-info python-any-r1 toolchain-funcs

DESCRIPTION="Dave Jones' handy, informative x86 CPU diagnostic utility"
HOMEPAGE="http://www.codemonkey.org.uk/projects/x86info/"
# Upstream stopped versioned releases entirely
COMMIT="8ea5ed19fae1d209eba9257171a10f7afd474618"
SRC_URI="https://github.com/kernelslacker/x86info/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="sys-apps/pciutils:="
DEPEND="
	${PYTHON_DEPS}
	${RDEPEND}"

CONFIG_CHECK="~MTRR ~X86_CPUID"
S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	#"${FILESDIR}"/1.21-pic.patch
	"${FILESDIR}"/${PN}-1.24-pic.patch #270388
	#"${FILESDIR}"/${PN}-1.29-parallel-make-cleanup.patch
	#"${FILESDIR}"/${PN}-1.30-fix-build-system.patch
)

pkg_setup() {
	linux-info_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# These flags taken from the 1.29 ebuild
	append-flags -Wall -Wshadow -Wextra -Wmissing-declarations \
		-Wdeclaration-after-statement -Wredundant-decls
	append-ldflags -Wl,-z,relro,-z,now

	tc-export CC
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
