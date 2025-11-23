# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="source"

inherit desktop toolchain-funcs xdg java-pkg-2

DESCRIPTION="Tool for building Expert Systems (Java version)"
HOMEPAGE="http://www.clipsrules.net/"

CLPN="clips_jni_$(ver_cut 1)$(ver_cut 2)"
SRC_URI="https://sourceforge.net/projects/clipsrules/files/CLIPS/${PV}/${CLPN}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN^^}"

LICENSE="public-domain"
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE="examples"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

PATCHES=(
	"${FILESDIR}/${PN}-library-src_makefile.lnx-remove_hardcoded.patch"
	"${FILESDIR}/${PN}-makefile.lnx-java.patch"
)

src_prepare() {
	xdg_environment_reset
	tc-export AR CC

	rm ./*.dll ./*.jar ./*jnilib || die
	java-pkg-2_src_prepare

	default
}

src_compile() {
	pushd library-src || die
	emake -f makefile.lnx
	popd || die

	if use examples ; then
		emake -f makefile.lnx
	else
		emake -f makefile.lnx clipsjni ide
	fi
}

src_install() {
	java-pkg_doso ./library-src/libCLIPSJNI.so
	java-pkg_dojar CLIPSIDE.jar CLIPSJNI.jar

	local e
	for e in clipside clipsjni ; do
		java-pkg_dolauncher ${e} --jar ${e^^}.jar
	done

	doicon ./java-src/net/sf/clipsrules/jni/examples/ide/resources/CLIPS.png

	make_desktop_entry  \
		clipside CLIPSIDE CLIPS "Development;IDE"
	make_desktop_entry  \
		clipsjni CLIPSJNI CLIPS "Development;ConsoleOnly;" "Terminal=true"

	if use examples ; then
		insinto /usr/share/clipsjni/examples
		doins ./*Demo.jar
	fi

	use source && java-pkg_dosrc ./java-src
}

pkg_preinst() {
	java-pkg-2_pkg_preinst
	xdg_pkg_preinst
}
