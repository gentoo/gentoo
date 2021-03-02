# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

GITID="06cc8a637efd9097af4f138b1b7c755120ffaa88"
DESCRIPTION="HTML to ASCII converter programmed to handle incorrect html"
HOMEPAGE="https://bhaak.net/vilistextum/"
SRC_URI="https://github.com/bhaak/vilistextum/archive/${GITID}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GITID}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="unicode"

DEPEND="virtual/libiconv"

PATCHES=(
	"${FILESDIR}"/${PN}-2.8.0-prefix.patch
	"${FILESDIR}"/${PN}-2.8.0.20200411-blockquote.patch
	"${FILESDIR}"/${PN}-2.8.0-towlower.patch
	"${FILESDIR}"/${PN}-2.8.0.20200411-list-alignment.patch
	"${FILESDIR}"/${P}-static.patch
)

src_prepare() {
	default
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
