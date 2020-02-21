# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

USE_DOTNET="net35 net40 net45"
PATCHDIR="${FILESDIR}/2.2/"

inherit base eutils systemd dotnet user autotools autotools-utils

DESCRIPTION="XSP is a small web server that can host ASP.NET pages"
HOMEPAGE="http://www.mono-project.com/ASP.NET"

EGIT_COMMIT="e272a2c006211b6b03be2ef5bbb9e3f8fefd0768"
SRC_URI="https://github.com/mono/xsp/archive/${EGIT_COMMIT}.zip -> ${P}.zip"
S="${WORKDIR}/xsp-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc test developer"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/aclocal-fix.patch"

	if [ -z "$LIBTOOL" ]; then
		LIBTOOL=`which glibtool 2>/dev/null`
		if [ ! -x "$LIBTOOL" ]; then
			LIBTOOL=`which libtool`
		fi
	fi
	eaclocal -I build/m4/shamrock -I build/m4/shave $ACLOCAL_FLAGS
	if test -z "$NO_LIBTOOLIZE"; then
		${LIBTOOL}ize --force --copy
	fi
	eautoconf
}

src_configure() {
	myeconfargs=("--enable-maintainer-mode")
	use test && myeconfargs+=("--with_unit_tests")
	use doc || myeconfargs+=("--disable-docs")
	eautomake --gnu --add-missing --force --copy #nowarn
	autotools-utils_src_configure
	./configure || die
}

METAFILETOBUILD=xsp.sln

src_compile() {
	exbuild xsp.sln
	if use developer; then
		exbuild /p:DebugSymbols=True ${METAFILETOBUILD}
	else
		exbuild /p:DebugSymbols=False ${METAFILETOBUILD}
	fi
}

pkg_preinst() {
	enewgroup aspnet
	enewuser aspnet -1 -1 /tmp aspnet

	# enewuser www-data
	# www-data - is from debian, i think it's the same as aspnet here
}

src_install() {
	mv_command="cp -ar" autotools-utils_src_install
	newinitd "${PATCHDIR}"/xsp.initd xsp
	newinitd "${PATCHDIR}"/mod-mono-server-r1.initd mod-mono-server
	newconfd "${PATCHDIR}"/xsp.confd xsp
	newconfd "${PATCHDIR}"/mod-mono-server.confd mod-mono-server

	insinto /etc/xsp4
	doins "${FILESDIR}"/systemd/mono.webapp
	insinto /etc/xsp4/conf.d
	# mono-xsp4.service was original name from
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=770458;filename=mono-xsp4.service;att=1;msg=5
	# I think that using the same commands as in debian
	#     systemctl start mono-xsp4.service
	#     systemctl start mono-xsp4
	# is better than to have shorter command
	#     systemctl start xsp
	#
	# insinto /usr/lib/systemd/system
	systemd_dounit "${FILESDIR}"/systemd/mono-xsp4.service

	keepdir /var/run/aspnet
}
