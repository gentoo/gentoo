# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="The Yate AV Suite"
HOMEPAGE="http://yate.null.ro/"

if [[ ${PV} == 9999 ]] ; then
	ESVN_REPO_URI="http://voip.null.ro/svn/yate/trunk"
	inherit subversion
	KEYWORDS=""
else
	SRC_URI="http://voip.null.ro/tarballs/${PN}5/${P}-1.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="doc cpu_flags_x86_sse2 sctp dahdi zaptel wpcard tdmcard wanpipe +ilbc +ilbc-webrtc +isac-float isac-fixed postgres mysql +gsm +speex h323 spandsp +ssl qt4 +zlib amrnb"

RDEPEND="
	postgres? ( dev-db/postgresql )
	mysql? ( virtual/mysql )
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )
	ssl? ( dev-libs/openssl )
	h323? ( net-libs/h323plus )
	zlib? ( sys-libs/zlib )
	qt4? ( dev-qt/qtgui:4 dev-qt/designer:4 )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	spandsp? ( >=media-libs/spandsp-0.0.3 )
	dahdi? ( net-misc/dahdi )
"
DEPEND="doc? ( || ( app-doc/doxygen dev-util/kdoc ) )
	virtual/pkgconfig
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/dont-mess-with-cflags.patch
	eautoreconf
	./yate-config.sh || die
}

#fdsize, inline, rtti: keep default values
#internalregex: use system
#coredumper: not in the tree, bug 118716
#wanpipe, wphwec: not in the tree, bug 188939
#amrnb: not in tree!
#zaptel: ??
src_configure() {
	econf \
		--with-archlib=$(get_libdir) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable sctp) \
		$(use_enable dahdi) \
		$(use_enable zaptel) \
		$(use_enable wpcard) \
		$(use_enable tdmcard) \
		$(use_enable wanpipe) \
		$(use_enable ilbc) \
		$(use_enable ilbc-webrtc) \
		$(use_enable isac-float) \
		$(use_enable isac-fixed) \
		$(use_with postgres libpq) \
		$(use_with mysql) \
		$(use_with gsm libgsm) \
		$(use_with speex libspeex) \
		$(use_with amrnb) \
		$(use_with spandsp) \
		$(use_with h323 openh323 /usr) \
		$(use_with h323 pwlib /usr) \
		$(use_with ssl openssl) \
		$(use_with qt4 libqt4)
}

src_compile() {
	emake -j1
}

src_install() {
	if use doc; then
		emake DESTDIR="${ED}" install
	else
		emake DESTDIR="${ED}" install-noapi
	fi
}
