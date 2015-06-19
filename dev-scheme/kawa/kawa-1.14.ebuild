# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/kawa/kawa-1.14.ebuild,v 1.1 2015/04/27 20:26:48 monsieurp Exp $
EAPI=5

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2

DESCRIPTION="Kawa, the Java-based Scheme system & Language Framework"
HOMEPAGE="http://www.gnu.org/software/kawa/"
XQTS_Ver="1_0_3"
SRC_URI="mirror://gnu/kawa/${P}.tar.gz
		 xqtests? ( http://www.w3.org/XML/Query/test-suite/XQTS_${XQTS_Ver}.zip )"

LICENSE="MIT public-domain
		 jemacs? ( GPL-2 )
		 krl? ( GPL-2 )"
SLOT="0"
KEYWORDS="~x86"
IUSE="+awt echo2 +frontend jemacs krl +sax servlets +swing swt +xml xqtests"

CDEPEND="( >=virtual/jdk-1.6 )
	frontend? ( sys-libs/readline:0 )
	sax? ( dev-java/sax:0 )
	echo2? ( dev-java/echo2 )
	swt? ( dev-java/swt:3.5 )
	servlets? ( java-virtuals/servlet-api:3.0 )"
DEPEND="${CDEPEND}
		xqtests? ( app-arch/unzip:0 )"
RDEPEND="${CDEPEND}"

xtestsuite="XQTS_${XQTS_Ver}"

src_unpack () {
	unpack kawa-${PV}.tar.gz || die
	if use xqtests; then
		mkdir "${WORKDIR}/${xtestsuite}" || die
		cd "${WORKDIR}/${xtestsuite}" || die
		unpack ${xtestsuite}.Zip || die
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_configure() {
	# speeds up one-shot ebuilds.
	myconf="--disable-dependency-tracking"
	if use jemacs && ! use swing; then
		echo
		einfo "Although the swing USE flag is disabled you chose to enable jemacs,"
		einfo "so swing is enabled anyway."
		echo
		myconf="${myconf} --with-swing"
	else
		myconf="${myconf} $(use_with swing)"
	fi
	if use xqtests; then
		myconf="${myconf} $(use_with xqtests XQTS=${WORKDIR}/${xtestsuite})"
	fi
	if use servlets; then
		myconf="${myconf} --with-servlet=$(java-pkg_getjar servletapi-2.4 servlet-api.jar)"
	fi
	if use swt; then
		myconf="${myconf} --with-swt=$(java-pkg_getjar swt-3.5 swt.jar)"
	fi

	econf ${myconf} $(use_enable frontend kawa-frontend) \
		  $(use_enable xml) \
		  $(use_enable krl brl) \
		  $(use_enable echo2) \
		  $(use_enable jemacs) \
		  $(use_with awt) \
		  $(use_with sax sax2) \
		  --with-java-source=$(java-pkg_get-source) || die "econf failed."
}

src_compile() {
	emake -j1 || die "emake failed."
}

src_install () {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	rm -rv "${D}"/usr/share/java/ || die "rm -rv failed"

	java-pkg_newjar kawa-${PV}.jar || die

	java-pkg_dolauncher "kawa" --main kawa.repl || die "dolauncher failed"
	java-pkg_dolauncher "qexo" --main kawa.repl --pkg_args \
		"--xquery" || die "dolauncher qexo failed"
	if use servlets; then
		java-pkg_dolauncher "kawa-cgi-servlet" --main \
			gnu.kawa.servlet.CGIServletWrapper || die
	fi
	if use jemacs; then
		java-pkg_dolauncher "jemacs" --main \
			gnu.jemacs.lang.ELisp || die
	fi

	use source && java-pkg_dosrc kawa/* gnu/*

	dodoc ChangeLog TODO README NEWS || die
	doinfo doc/kawa.info* || die
	cp doc/kawa.man doc/kawa.2 || die
	cp doc/qexo.man doc/qexo.2 || die
	doman doc/*.2 || die
}
