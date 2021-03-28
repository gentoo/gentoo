# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: We can probably yank the USE_DOTNET/dotnet.eclass stuff
# but let's be conservative for now
USE_DOTNET="net35 net40 net45"
inherit autotools dotnet systemd user

EGIT_COMMIT="e272a2c006211b6b03be2ef5bbb9e3f8fefd0768"
DESCRIPTION="XSP is a small web server that can host ASP.NET pages"
HOMEPAGE="http://www.mono-project.com/ASP.NET"
SRC_URI="https://github.com/mono/xsp/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/xsp-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="developer doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/aclocal-fix.patch"
)

METAFILETOBUILD=xsp.sln

src_prepare() {
	default

	eaclocal -I build/m4/shamrock -I build/m4/shave ${ACLOCAL_FLAGS}
	if test -z "${NO_LIBTOOLIZE}" ; then
		_elibtoolize --force --copy
	fi

	eautoconf
	eautomake --gnu --add-missing --force --copy
}

src_configure() {
	local myeconfargs=(
		"--enable-maintainer-mode"
	)

	use test && myeconfargs+=( "--with_unit_tests" )
	use doc || myeconfargs+=( "--disable-docs" )

	econf "${myeconfargs[@]}"
}

#src_compile() {
#	exbuild xsp.sln

#	if use developer ; then
#		exbuild /p:DebugSymbols=True ${METAFILETOBUILD}
#	else
#		exbuild /p:DebugSymbols=False ${METAFILETOBUILD}
#	fi
#}

pkg_preinst() {
	enewgroup aspnet
	enewuser aspnet -1 -1 /tmp aspnet

	# enewuser www-data
	# www-data - is from debian, i think it's the same as aspnet here
}

src_install() {
	default

	local PATCHDIR="${FILESDIR}/2.2/"

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
