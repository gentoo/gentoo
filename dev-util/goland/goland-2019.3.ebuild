# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

SLOT=0

SRC_URI="http://download.jetbrains.com/go/${P}.tar.gz"
DESCRIPTION="Golang IDE by JetBrains"
HOMEPAGE="http://www.jetbrains.com/go"

KEYWORDS="~amd64"
LICENSE="|| ( JetBrains-business JetBrains-classroom JetBrains-educational JetBrains-individual )
	Apache-2.0
	BSD
	CC0-1.0
	CDDL
	CDDL-1.1
	EPL-1.0
	GPL-2
	GPL-2-with-classpath-exception
	ISC
	LGPL-2.1
	LGPL-3
	MIT
	MPL-1.1
	OFL
	ZLIB
"

RESTRICT="bindist mirror"

QA_PREBUILT="opt/${P}/*"

S=${WORKDIR}/GoLand-${PV}

RDEPEND="dev-lang/go"

src_prepare() {
	default
	if ! use arm; then
		rm -rf bin/fsnotifier-arm || die
	fi
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{${PN}.sh,fsnotifier{,64}}

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "gogland" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
