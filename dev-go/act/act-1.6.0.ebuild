# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base toolchain-funcs

DESCRIPTION="Automated Component Toolkit code generator"
HOMEPAGE="https://github.com/Autodesk/AutomaticComponentToolkit"
SRC_URI="https://github.com/Autodesk/AutomaticComponentToolkit/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AutomaticComponentToolkit-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="strip test"

# Package does not follow the usual go directory structure
# Functions borrowed from dev-lang/go ebuild.
go_arch() {
	# By chance most portage arch names match Go
	local portage_arch=$(tc-arch $@)
	case "${portage_arch}" in
		x86)	echo 386;;
		x64-*)	echo amd64;;
		*)		echo "${portage_arch}";;
	esac
}

go_arm() {
	case "${1:-${CHOST}}" in
		armv5*) echo 5;;
		armv6*) echo 6;;
		armv7*) echo 7;;
		*)
			die "unknown GOARM for ${1:-${CHOST}}"
			;;
	esac
}

src_compile() {
	export GOARCH=$(go_arch)
	export GOOS=linux
	if [[ ${ARCH} == arm ]]; then
		export GOARM=$(go_arm)
	fi

	cd "${S}"/Source || die
	go build -o ../${PN} *.go || die
}

src_install() {
	newbin "${S}"/${PN} ${PN}
	einstalldocs
	dodoc -r Documentation/.
}
