# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

DESCRIPTION="Html to ascii converter specifically programmed to get the best out of incorrect html"
HOMEPAGE="http://bhaak.dyndns.org/vilistextum/"
SRC_URI="http://bhaak.dyndns.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
#IUSE="unicode kde"
IUSE="unicode"

DEPEND="virtual/libiconv"
RDEPEND=""
# KDE support will be available once a version of kaptain in stable
#	 kde? ( kde-misc/kaptain )"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-gentoo.diff" \
		"${FILESDIR}/${P}-prefix.patch" \
		"${FILESDIR}/${P}-darwin11.patch" \
		"${FILESDIR}/${P}-blockquote.patch"
	eautoreconf
}

get_locale() {
	locale -a | grep -i "$1\.utf.*8\$"
}

find_locale() {
	local l t

	# we basically prefer to find en_US.UTF-8, but it may not always be
	# available, in which case it is better not to hardcode to use it
	l=$(get_locale en_US)
	if [[ -z ${l} ]] ; then
		for t in "en_GB" "en_.*" ".*" ; do
			l=$(get_locale ${t})
			if [[ -n ${l} ]] ; then
				l=${l%%$'\n'*}
				break;
			fi
		done
	fi
	[[ -z ${l} ]] && die "Failed to find a unicode locale"
	echo "${l}"
}

src_configure() {
	# need hardwired locale simply because locale -a | grep -i utf-8 | head -n1
	# isn't always returning the most sensical (and working) locale
	econf \
		$(use_enable unicode multibyte) \
		$(use_with unicode unicode-locale $(find_locale))
}

src_test() {
	if $(locale -a | grep -iq "en_US\.utf.*8"); then
		emake -j1 check
	else
		ewarn "If you like to run the test,"
		ewarn "please make sure en_US.UTF-8 is installed."
		die "en_US.UTF-8 locale is missing"
	fi
}

src_install() {
	default
	dohtml doc/*.html
}
