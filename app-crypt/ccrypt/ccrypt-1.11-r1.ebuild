# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Encryption and decryption"
HOMEPAGE="https://sourceforge.net/projects/ccrypt/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"
IUSE="emacs"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

BEPEND="emacs? ( >=app-editors/emacs-23.1:* )"

src_configure() {
	econf \
		$(use_enable emacs)
}
