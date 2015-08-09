# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils mono multilib java-pkg-2

DESCRIPTION="Java VM for .NET"
HOMEPAGE="http://www.ikvm.net/ http://weblog.ikvm.net/"
SRC_URI="http://www.frijters.net/openjdk6-b22-stripped.zip
	http://www.frijters.net/${PN}src-${PV}.zip"
LICENSE="ZLIB GPL-2-with-linking-exception"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=dev-lang/mono-2
	dev-libs/glib"
DEPEND="${RDEPEND}
	!dev-dotnet/ikvm-bin
	>=dev-dotnet/nant-0.85
	virtual/jdk:1.6
	app-arch/unzip
	virtual/pkgconfig
	app-arch/sharutils"

src_prepare() {
	# Fix unmappable character for encoding ASCII, bug #399729
	epatch "${FILESDIR}"/${PN}-0.46.0.2-unmappable-character.patch

	# We cannot rely on Mono Crypto Service Provider as it doesn't work inside
	# sandbox, we simply hard-code the path to a bundled key like Debian does.
	epatch "${FILESDIR}"/${PN}-0.46.0.1-key.patch
	uudecode < "${FILESDIR}"/mono.snk.uu || die

	# Ensures that we use Mono's bundled copy of SharpZipLib instead of relying
	# on ikvm-bin one
	sed -i -e 's:../bin/ICSharpCode.SharpZipLib.dll:ICSharpCode.SharpZipLib.dll:' \
		ikvmc/ikvmc.build ikvmstub/ikvmstub.build || die

	sed -i -e 's:pkg-config --cflags:pkg-config --cflags --libs:' \
		native/native.build || die

	mkdir -p "${T}"/home/test
	java-pkg-2_src_prepare
}

src_configure() {
	:
}

src_compile() {
	XDG_CONFIG_HOME="${T}/home/test" nant -t:mono-2.0 signed || die "ikvm build failed"
}

generate_pkgconfig() {
	ebegin "Generating .pc file"
	local dll LSTRING="Libs:"
	dodir "/usr/$(get_libdir)/pkgconfig"
	cat <<- EOF -> "${D}/usr/$(get_libdir)/pkgconfig/${PN}.pc"
		prefix=/usr
		exec_prefix=\${prefix}
		libdir=\${prefix}/$(get_libdir)
		Name: IKVM.NET
		Description: An implementation of Java for Mono and the Microsoft .NET Framework.
		Version: ${PV}
	EOF
	for dll in "${S}"/bin/IKVM.*.dll
	do
		LSTRING="${LSTRING} -r:"'${libdir}'"/mono/IKVM/${dll##*/}"
	done
	printf "${LSTRING}" >> "${D}/usr/$(get_libdir)/pkgconfig/${PN}.pc"
	PKG_CONFIG_PATH="${D}/usr/$(get_libdir)/pkgconfig/" pkg-config --silence-errors --libs ikvm &> /dev/null
	eend $?
}

src_install() {
	local dll dllbase exe
	insinto /usr/$(get_libdir)/${PN}
	doins bin/*.exe

	dodir /bin
	for exe in bin/*.exe
	do
		exebase=${exe##*/}
		ebegin "Generating wrapper for ${exebase} -> ${exebase%.exe}"
		make_wrapper ${exebase%.exe} "mono /usr/$(get_libdir)/${PN}/${exebase}"
		eend $? || die "Failed generating wrapper for ${exebase}"
	done

	generate_pkgconfig || die "generating .pc failed"

	for dll in bin/IKVM.*.dll
	do
		dllbase=${dll##*/}
		ebegin "Installing and registering ${dllbase}"
		gacutil -i bin/${dllbase} -root "${D}"/usr/$(get_libdir) \
			-gacdir /usr/$(get_libdir) -package IKVM &>/dev/null
		eend $? || die "Failed installing ${dllbase}"
	done
}
