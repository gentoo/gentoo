# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="A command line interface to KeePass database files"
HOMEPAGE="http://kpcli.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/kpcli/${P}.pl"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/Clone
	dev-perl/Crypt-Rijndael
	dev-perl/File-KeePass
	dev-perl/Math-Random-ISAAC
	dev-perl/Sort-Naturally
	dev-perl/Sub-Install
	dev-perl/TermReadKey
	dev-perl/Term-ReadLine-Gnu
	dev-perl/Term-ShellUI"

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}/${P}.pl" "${S}/${PN}" || die
}

src_compile() { :; }

src_install() {
	dobin kpcli
}

pkg_postinst() {
	# Not packaged in Gentoo yet, but we'd be interested in: 
	# Both Authen::OATH and Convert::Base32 for "time-based-one-time-only password support", 
	# https://en.wikipedia.org/wiki/Time-based_One-time_Password_algorithm
	optfeature "X clipboard support" "dev-perl/Capture-Tiny dev-perl/Clipboard"
	optfeature "password quality check" dev-perl/Data-Password
	optfeature "better password quality check" dev-perl/Data-Password-passwdqc
	optfeature "importing Password Safe v3 databases" dev-perl/Crypt-PWSafe3
}
