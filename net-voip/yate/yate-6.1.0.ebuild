# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="The Yate AV Suite"
HOMEPAGE="http://yate.null.ro/"

if [[ ${PV} == 9999 ]] ; then
	ESVN_REPO_URI="http://voip.null.ro/svn/yate/trunk"
	inherit subversion
	KEYWORDS=""
else
	SRC_URI="http://voip.null.ro/tarballs/${PN}6/${P}-1.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="doc cpu_flags_x86_sse2 sctp dahdi zaptel wpcard tdmcard wanpipe +ilbc +ilbc-webrtc +isac-float isac-fixed postgres mysql +gsm +speex spandsp +ssl +zlib amrnb"

RDEPEND="
	postgres? ( dev-db/postgresql:* )
	mysql? ( virtual/mysql )
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )
	ssl? ( dev-libs/openssl:0 )
	zlib? ( sys-libs/zlib )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	spandsp? ( >=media-libs/spandsp-0.0.3 )
	dahdi? ( net-misc/dahdi )
"
DEPEND="doc? ( app-doc/doxygen )
	virtual/pkgconfig
	${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-6.0.0-dont-mess-with-cflags.patch )

src_prepare() {
	default_src_prepare
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
		--without-libqt4 \
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
		$(use_with ssl openssl)
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
	newinitd "${FILESDIR}"/yate.initd yate
	newconfd "${FILESDIR}"/yate.confd yate
}
