# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

GITID="f299bb5e5f661c345c4b85a3e8de9ad8615ad17a"
DESCRIPTION="HTML to ASCII converter programmed to handle incorrect html"
HOMEPAGE="https://bhaak.net/vilistextum/"
SRC_URI="https://github.com/bhaak/vilistextum/tarball/${GITID} -> ${P}.tar.gz"
S="${WORKDIR}/bhaak-${PN}-${GITID:0:7}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="unicode"

DEPEND="virtual/libiconv"
RDEPEND=""

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.8.0-gentoo.patch"
	eapply "${FILESDIR}/${PN}-2.8.0-prefix.patch"
	eapply "${FILESDIR}/${PN}-2.8.0-blockquote.patch"
	eapply "${FILESDIR}/${PN}-2.8.0-towlower.patch"

	eapply_user
	eautoreconf

	# wcscasecmp needs extensions, which aren't enabled
	export ac_cv_func_wcscasecmp=no
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
	doman doc/${PN}.1
	dodoc doc/changes.xhtml doc/htmlmail.xhtml
}
