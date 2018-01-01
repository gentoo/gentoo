# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils bash-completion-r1

DESCRIPTION="unix-like reverse engineering framework and commandline tools"
HOMEPAGE="http://www.radare.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/radare/radare2"
else
	SRC_URI="https://github.com/radare/radare2/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="ssl libressl +system-capstone"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	system-capstone? ( dev-libs/capstone:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	econf \
		$(use_with ssl openssl) \
		$(use_with system-capstone syscapstone)
}

src_install() {
	default

	insinto /usr/share/zsh/site-functions
	doins doc/zsh/_*

	newbashcomp doc/bash_autocompletion.sh "${PN}"
	bashcomp_alias "${PN}" rafind2 r2 rabin2 rasm2 radiff2

	# a workaround for unstable $(INSTALL) call, bug #574866
	local d
	for d in doc/*; do
		if [[ -d $d ]]; then
			rm -rfv "$d" || die "failed to delete '$d'"
		fi
	done
}
