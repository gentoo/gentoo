# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-opt-2 multibuild

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/perl6/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/perl6/${PN}/tarball/${PV} -> ${P}.tar.gz"
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Not Quite Perl, a Perl 6 bootstrapping compiler"
HOMEPAGE="http://rakudo.org/"

LICENSE="Artistic-2"
SLOT="0"
IUSE="doc clang java +moar test"
REQUIRED_USE="|| ( java moar )"

CDEPEND="java? (
		dev-java/asm:4
		dev-java/jline:0
		dev-java/jna:4
	)
	moar? ( ~dev-lang/moarvm-${PV}[clang=] )"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.7 )"
DEPEND="${CDEPEND}
	clang? ( sys-devel/clang )
	java? ( >=virtual/jdk-1.7 )
	dev-lang/perl"

pkg_pretend() {
	if has_version dev-lang/rakudo || has_version dev-lang/nqp; then
		ewarn "NQP is known to fail compilation/installation with Rakudo and/or NQP"
		ewarn "already being installed. So if it fails, try uninstalling both"
		ewarn "dev-lang/nqp and dev-lang/rakudo, then do a new installation."
		ewarn "(see Bug #584394)"
	fi
}

java_prepare() {
	# Don't clean stage0 jars.
	einfo "Cleaning upstream jars"
	java-pkg_clean 3rdparty/

	# Don't use jars we just deleted.
	sed -i -r 's/(:3rdparty[^:]*)+/:${THIRDPARTY_JARS}/g' \
		src/vm/jvm/runners/nqp-j || die
}

src_prepare() {
	MULTIBUILD_VARIANTS=()
	use moar && MULTIBUILD_VARIANTS+=( moar )
	use java && MULTIBUILD_VARIANTS+=( jvm )

	multibuild_copy_sources

	# This will pull in conditional java_prepare
	default
}

nqp_configure() {
	pushd "${BUILD_DIR}" > /dev/null || die
	local myconfargs=(
		"--backend=${MULTIBUILD_VARIANT}"
		"--prefix=/usr" )

	perl Configure.pl "${myconfargs[@]}" || die
	popd || die
}

nqp_compile() {
	if [[ "${MULTIBUILD_VARIANT}" = jvm ]]; then
		emake -j1 \
			-C "${BUILD_DIR}" \
			THIRDPARTY_JARS=$(java-pkg_getjars --with-dependencies asm-4,jline,jna-4) \
			JAVAC="$(java-pkg_get-javac) $(java-pkg_javac-args)"
	elif [[ "${MULTIBUILD_VARIANT}" = moar ]]; then
		emake -j1 \
			-C "${BUILD_DIR}"
	fi
}

nqp_test() {
	emake -j1 \
		-C "${BUILD_DIR}" \
		test
}

nqp_install() {
	# This is the actual reason we need multibuild.eclass.
	# We need to distinguish the install procedure for MoarVM and JVM backends.
	case "${MULTIBUILD_VARIANT}" in
		moar)
			emake \
				DESTDIR="${ED}" \
				-C "${BUILD_DIR}" \
				install
			;;
		jvm)
			pushd "${BUILD_DIR}" > /dev/null || die
			# Set JAVA_PKG_JARDEST early.
			java-pkg_init_paths_

			# Upstream sets the classpath to this location. Perhaps it's
			# used to locate the additional libraries?
			java-pkg_addcp "${JAVA_PKG_JARDEST}"

			insinto "${JAVA_PKG_JARDEST}"
			local jar

			for jar in *.jar; do
				if has ${jar} ${PN}.jar ${PN}-runtime.jar; then
					# jars for NQP itself.
					java-pkg_dojar ${jar}
				else
					# jars used by NQP.
					doins ${jar}
				fi
			done

			# Upstream uses -Xbootclasspath/a, which is faster due to lack
			# of verification, but gjl isn't flexible enough yet. :(
			java-pkg_dolauncher ${PN}-j --main ${PN}
			dosym ${PN}-j /usr/bin/${PN}
			dobin tools/jvm/eval-client.pl
			popd > /dev/null || die
			;;
		*)
			die "Unknown MULTIBUILD_VARIANT ${MULTIBUILD_VARIANT}."
			;;
	esac
}

src_configure() {
	multibuild_foreach_variant nqp_configure
}

src_compile() {
	multibuild_foreach_variant nqp_compile
}

src_test() {
	multibuild_foreach_variant nqp_test
}

src_install() {
	multibuild_foreach_variant nqp_install

	dodoc CREDITS README.pod
	use doc && dodoc -r docs/*
}
