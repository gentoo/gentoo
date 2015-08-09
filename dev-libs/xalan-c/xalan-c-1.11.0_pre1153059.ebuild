# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs eutils flag-o-matic multilib

DESCRIPTION="XSLT processor for transforming XML into HTML, text, or other XML types"
HOMEPAGE="http://xml.apache.org/xalan-c/"
SRC_URI="mirror://gentoo/Xalan-C_r${PV#*_pre}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc examples nls threads"

RDEPEND=">=dev-libs/xerces-c-2.8.0"
#	icu? ( dev-libs/icu )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/xml-xalan/c"

pkg_setup() {
#	export ICUROOT="/usr"
	export XALANCROOT="${S}"
}

src_prepare() {
	epatch \
		"${FILESDIR}/1.11.0_pre797991-as-needed.patch" \
		"${FILESDIR}/1.11.0_pre797991-bugfixes.patch" \
		"${FILESDIR}/1.11.0_pre797991-parallel-build.patch"

	# - do not run configure in runConfigure
	# - echo the export commands instead exporting the vars
	# - remove -O3
	# - make sure our {C,CXX}FLAGS get respected
	sed -i \
		-e '/\/configure/d' \
		-e 's/^export \([a-zA-Z_]*\)/echo export \1=\\"$\1\\"/' \
		-e 's/\(debugflag\)="-O.\? /\1="/' \
		-e 's/^\(CXXFLAGS\)="$compileroptions/\1="${\1}/' \
		-e 's/^\(CFLAGS\)="$compileroptions/\1="${\1}/' \
		runConfigure || die "sed failed"
}

src_configure() {
	export XERCESCROOT="/usr"

	local target="linux"
	# add more if needed, see xerces-c-2.8.0-r1 ebuild

	local mloader="inmem"
	use nls && mloader="nls"
#	use icu && mloader="icu"

	local transcoder="default"
#	use icu && transcoder="icu"

	local thread="none"
	use threads && thread="pthread"

	local bitstobuild="32"
	$(has_m64) && bitstobuild="64"

	./runConfigure -p ${target} -c "$(tc-getCC)" -x "$(tc-getCXX)" \
		-m ${mloader} -t ${transcoder} \
		-r ${thread} -b ${bitstobuild} > configure.vars || die "runConfigure failed"

	eval $(grep export configure.vars)

	default
}

src_compile() {
	default

	if use doc ; then
		mkdir build
		cd "${S}/xdocs"
		doxygen DoxyfileXalan
	fi
}

src_install() {
	default

	if use doc ; then
		dodir /usr/share/doc/${PF}
		dohtml -r build/docs/apiDocs/*
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r samples/*
	fi
}

pkg_postinst() {
	ewarn "If you are upgrading you should run"
	ewarn "    revdep-rebuild --library=libxalan-c.so.110"
	ewarn "if using portage or"
	ewarn "    reconcilio --library libxalan-c.so.110"
	ewarn "if using paludis as your package manager."
}
