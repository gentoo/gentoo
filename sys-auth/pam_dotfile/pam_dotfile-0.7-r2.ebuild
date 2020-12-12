# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pam

MY_P="${P/_beta/beta}"

DESCRIPTION="pam module to allow password-storing in \$HOME/dotfiles"
HOMEPAGE="http://0pointer.de/lennart/projects/pam_dotfile/
	https://github.com/gentoo/pam_dotfile/"
SRC_URI="http://0pointer.de/lennart/projects/pam_dotfile/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

BDEPEND="doc? ( www-client/lynx )"
RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc lynx)
		--with-pammoddir=$(getpam_mod_dir)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# kill the libtool archives
	rm -rf "${D}"/$(getpam_mod_dir)/*.la || die
}
