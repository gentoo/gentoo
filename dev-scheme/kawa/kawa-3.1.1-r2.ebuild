# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="source"

inherit autotools java-pkg-2

DESCRIPTION="Java-based Scheme system & Language Framework"
HOMEPAGE="https://www.gnu.org/software/kawa/"
SRC_URI="https://gitlab.com/kashell/${PN^}/-/archive/${PV}/${PN^}-${PV}.tar.gz"
S="${WORKDIR}/${PN^}-${PV}"

LICENSE="MIT public-domain jemacs? ( GPL-2 ) krl? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+awt +frontend jemacs krl +sax servlets +swing +xml"
RESTRICT="test"  # fails

COMMON_DEPEND="
	frontend? ( sys-libs/readline:0 )
	sax? ( dev-java/sax:0 )
	servlets? ( java-virtuals/servlet-api:3.0 )
"
DEPEND="
	${COMMON_DEPEND}
	|| ( virtual/jdk:11 virtual/jdk:8 )
"
RDEPEND="
	${COMMON_DEPEND}
	>=virtual/jre-1.8
"

PATCHES=( "${FILESDIR}"/${PN}-${PV}-configure.ac-single_AM_INIT_AUTOMAKE.patch )

src_prepare() {
	default

	java-pkg-2_src_prepare
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable frontend kawa-frontend)
		$(use_enable jemacs)
		$(use_enable krl brl)
		$(use_enable xml)
		$(use_with awt)
		$(use_with sax sax2)
		--with-java-source="$(java-pkg_get-source)"
	)

	if use jemacs && ! use swing; then
		einfo "Although the swing USE flag is disabled you chose to enable jemacs,"
		einfo "so swing is enabled anyway."
		myconf+=( "--with-swing" )
	else
		myconf+=( "$(use_with swing)" )
	fi
	if use servlets; then
		myconf+=(
			"--with-servlet=$(java-pkg_getjar servlet-api-3.0 servlet-api.jar)"
		)
	fi

	econf "${myconf[@]}"
}

src_compile() {
	emake -j1
}

src_install() {
	use source && java-pkg_dosrc ./kawa/* ./gnu/*
	java-pkg_newjar ./lib/kawa.jar

	java-pkg_dolauncher "kawa" --main kawa.repl
	java-pkg_dolauncher "qexo" --main kawa.repl --pkg_args \ "--xquery"
	use servlets &&
		java-pkg_dolauncher "kawa-cgi-servlet" --main gnu.kawa.servlet.CGIServletWrapper
	use jemacs &&
		java-pkg_dolauncher "jemacs" --main gnu.jemacs.lang.ELisp

	einstalldocs
	doinfo doc/kawa.info*
	cp doc/kawa.man doc/kawa.1 || die
	cp doc/qexo.man doc/qexo.1 || die
	doman doc/*.1
}
