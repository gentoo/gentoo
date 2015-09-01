# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(  python2_7 )
inherit apache-module eutils python-any-r1

if [[ ${PV} == 9999 ]] ; then
	ESVN_REPO_URI="https://mod-spdy.googlecode.com/svn/trunk/src"
	ESVN_RESTRICT="export"
	EGIT_REPO_URI="https://chromium.googlesource.com/chromium/tools/depot_tools.git"
	EGIT_SOURCEDIR="${WORKDIR}/depot_tools"
	inherit subversion git-2
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Apache module for rewriting web pages to reduce latency and bandwidth"
HOMEPAGE="https://code.google.com/p/mod-spdy/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug test"

RDEPEND="sys-libs/zlib[minizip]"
DEPEND="${RDEPEND}"
if [[ ${PV} == 9999 ]] ; then
	DEPEND+=" net-misc/rsync"
fi

need_apache2_2

e() { echo "$@"; "$@" || die; }

EGCLIENT="${WORKDIR}/depot_tools/gclient"
egclient() { set -- "${EGCLIENT}" "$@"; e "$@"; }

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-2_src_unpack

		subversion_src_unpack
		mkdir -p "${ESVN_STORE_DIR}/${PN}" || die
		cd "${ESVN_STORE_DIR}/${PN}" || die

		egclient config ${ESVN_REPO_URI}
		egclient sync --force --nohooks --delete_unversioned_trees
		e rsync -a --exclude=".svn/" ./ "${S}/"
	else
		default
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.3.3-execinfo.patch

	# Make sure the system zlib is used.
	epatch "${FILESDIR}"/${PN}-0.9.3.3-system-zlib.patch
	find src/third_party/zlib/ -name '*.[ch]' -delete
}

src_configure() {
	tc-export AR CC CXX RANLIB
	tc-export_build_env BUILD_AR BUILD_CC BUILD_CXX

	local myconf=(
		-Dlinux_fpic=1
		-Duse_system_zlib=1
		-Duse_system_ssl=1
		-Dwerror=
	)
	#egclient runhooks "${myconf[@]}"
	e python src/build/gyp_chromium "${myconf[@]}"
}

echo_tests() { echo base_unittests spdy_{apache,common}_test; }
src_compile() {
	emake -C src \
		V=1 \
		BUILDTYPE=$(usex debug Debug Release) \
		mod_spdy \
		$(use test && echo_tests)
}

src_test() {
	cd src/out/Release
	local t
	for t in $(echo_tests) ; do
		e ./${t}
	done
}

src_install() {
	ln -sf src/out/*/libmod_spdy.so ${PN}.so || die
	APACHE2_MOD_FILE="${PWD}/${PN}.so"
	APACHE2_MOD_DEFINE="SPDY"
	apache-module_src_install

	# Workaround #471442
	cd "${S}/src"
	local conf="${T}/80_${PN}.conf"
	cat <<-EOF > "${conf}"
	<IfDefine SPDY>
	$(sed 's:@@APACHE_MODULEDIR@@:modules:' install/common/spdy.load.template)

	$(<install/common/spdy.conf.template)
	</IfDefine>
	EOF
	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${conf}"
}
