# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools bash-completion-r1 git-r3

DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
HOMEPAGE="http://mosh.mit.edu"
EGIT_REPO_URI="https://github.com/keithw/mosh.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+client examples +mosh-hardening +server ufw +utempter"
REQUIRED_USE="|| ( client server )
	examples? ( client )"

RDEPEND="dev-libs/protobuf
	sys-libs/ncurses:0=
	virtual/ssh
	client? ( dev-lang/perl
		dev-perl/IO-Tty )
	utempter? ( sys-libs/libutempter )"
DEPEND="${RDEPEND}
	dev-vcs/git[curl]
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-completion \
		$(use_enable client) \
		$(use_enable server) \
		$(use_enable examples) \
		$(use_enable ufw) \
		$(use_enable mosh-hardening hardening) \
		$(use_with utempter)
}

src_compile() {
	emake V=1
}

src_install() {
	default

	for myprog in $(find src/examples -type f -perm /0111) ; do
		newbin ${myprog} ${PN}-$(basename ${myprog})
		elog "${myprog} installed as ${PN}-$(basename ${myprog})"
	done

	# bug 477384
	dobashcomp conf/bash-completion/completions/mosh
}
