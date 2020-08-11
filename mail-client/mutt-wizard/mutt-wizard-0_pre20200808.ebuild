# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="A system for automatically configuring neomutt and isync"
HOMEPAGE="https://github.com/LukeSmithxyz/mutt-wizard"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LukeSmithxyz/mutt-wizard.git"
else
	COMMIT=1492a11b3ee0a1c3f5544a351089ff154521b68b
	SRC_URI="https://github.com/LukeSmithxyz/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	app-admin/pass
	mail-client/neomutt[notmuch]
	mail-mta/msmtp
	net-mail/isync[ssl]
"

# needed because there is no 'all' target defined in MAKEFILE
src_compile() {
	return 0;
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
	einstalldocs
}

pkg_postinst() {
	optfeature "enable viewing html mails" www-client/lynx
	optfeature "enable periodic syncing of mails" virtual/cron
	optfeature "enable viewing of simple images" media-gfx/imagemagick
	optfeature "enable notifications when syncing using mailsync" x11-libs/libnotify
	optfeature "enable command line address book" app-misc/abook
	optfeature "enable use of gpg for signing and verifying" app-crypt/gnupg
}
