# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

SV="$(ver_cut 1-2)"

# NOTES FOR BUMPING:
# 1. Remove the deps tarball in SRC_URI.
# 2. Emerge the package without network-sandbox to download all deps.
# 	 	- Ensure you fail before installation if you wish to do so.
# 		- sbt may download more deps when running tests.
# 		- "FEATURES='noclean -network-sandbox test' emerge -v1 dev-lang/scala"
# 3. cd to ${WORKDIR}
# 4. Create the deps tarball:
# 		- "XZ_OPT=-9 tar --owner=portage --group=portage -cJf /var/cache/distfiles/${P}-deps.tar.xz \
# 			.cache/ .sbt/"
# 5. Undo any temporary edits to the ebuild.

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="https://www.scala-lang.org/"
SRC_URI="
	https://github.com/scala/scala/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${P}-deps.tar.xz
"
LICENSE="Apache-2.0"
SLOT="${SV}/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs"

# Test scala.tools.tastytest.TastyTestJUnit.negFullCircle fails
# https://github.com/scala/bug/issues/12694
RESTRICT="test"

# JDK:11 else "Unrecognized VM option 'CMSClassUnloadingEnabled'"
DEPEND="
	app-arch/xz-utils:0
	>=dev-java/sbt-1.7.1:0
	media-gfx/graphviz
	virtual/jdk:11
"
RDEPEND="
	app-eselect/eselect-scala
	!dev-lang/scala-bin:0
	>=virtual/jre-1.8:*
"
PDEPEND="emacs? ( app-emacs/scala-mode:0 )"

PATCHES=( "${FILESDIR}/scala-2.13.10-no-git.patch" )

src_prepare() {
	# TODO: Remove when bumping to >2.13.10
	# https://github.com/scala/scala/pull/10204
	# Fixes "This wildcard import imports sbt.Import.License, which is shadowed by scala.build.License."
	sed 's/sbt._/sbt.{License => _, _}/' \
		-i project/Osgi.scala || die

	default
}

src_compile() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"

	einfo "=== sbt compile with jdk ${vm_version} ==="
	sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" compile || die

	einfo "=== sbt publishLocal with jdk ${vm_version} ==="
	sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" publishLocal || die
}

src_test() {
	einfo "=== sbt test with jdk ${vm_version} ==="
	sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" test || die
}

src_install() {
	local SCALADIR="/usr/share/${PN}-${SV}"

	pushd build/pack || die
	exeinto "${SCALADIR}/bin"
	doexe $(find bin/ -type f ! -iname '*.bat')

	for b in $(find bin/ -type f ! -iname '*.bat'); do
		local _name=$(basename "${b}")
		dosym "${SCALADIR}/bin/${_name}" "/usr/bin/${_name}-${SV}"
	done
	popd || die

	java-pkg_dojar $(find "${WORKDIR}"/.ivy2/local -name \*.jar -print)

	pushd build/quick/classes/scalaDist/man/man1 || die
	for i in *.1; do
		newman "${i}" "${i/./-${SV}.}"
	done
	popd || die

	#sources are .scala so no use for java-pkg_dosrc
	if use source; then
		pushd src || die
		insinto "${SCALADIR}/src"
		doins -r library library-aux reflect
		popd || die
	fi

	local DOCS=( "doc/README" )
	local HTML_DOCS=( "build/scaladoc" )
	use doc && einstalldocs
}
