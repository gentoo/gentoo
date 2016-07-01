# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit fdo-mime gnome2-utils dotnet versionator eutils

ROSLYN_COMMIT="16e117c2400d0ab930e7d89512f9894a169a0e6e"

DESCRIPTION="Integrated Development Environment for .NET"
HOMEPAGE="http://www.monodevelop.com/"
SRC_URI="http://download.mono-project.com/sources/monodevelop/${P}.tar.bz2
	https://github.com/mono/roslyn/archive/${ROSLYN_COMMIT}.zip -> roslyn-${ROSLYN_COMMIT}.zip
	https://launchpadlibrarian.net/68057829/NUnit-2.5.10.11092.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+subversion +git +gnome qtcurve"

COMMON_DEPEND="
	>=dev-lang/mono-3.2.8
	>=dev-dotnet/gtk-sharp-2.12.21:2
	>=dev-dotnet/nuget-2.8.7
	dev-dotnet/referenceassemblies-pcl
	net-libs/libssh2
	gnome? ( >=dev-dotnet/gnome-sharp-2.24.2-r1 )"
RDEPEND="${COMMON_DEPEND}
	dev-util/ctags
	sys-apps/dbus[X]
	>=www-servers/xsp-2
	git? ( dev-vcs/git )
	subversion? ( dev-vcs/subversion )
	!<dev-util/monodevelop-boo-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-java-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-database-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-gdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-mdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-vala-$(get_version_component_range 1-2)"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	x11-misc/shared-mime-info
	x11-terms/xterm
	app-arch/unzip"

MAKEOPTS="${MAKEOPTS} -j1" #nowarn
S="${WORKDIR}/${PN}-6.0"

src_unpack() {
	cd "${T}"
	unpack NUnit-2.5.10.11092.zip

	cd "${WORKDIR}"
	unpack "${P}.tar.bz2"

	# roslyn dlls are missing from monodevelop tarball
	cd "${S}/external"
	unpack "roslyn-${ROSLYN_COMMIT}.zip"
	rm -rf "roslyn"
	mv "roslyn-${ROSLYN_COMMIT}" "roslyn"
}

src_prepare() {
	# Remove the git rev-parse (changelog?)
	sed -i '/<Exec.*rev-parse/ d' "${S}/src/core/MonoDevelop.Core/MonoDevelop.Core.csproj" || die
	# Set specific_version to prevent binding problem
	# when gtk#-3 is installed alongside gtk#-2
	find "${S}" -name '*.csproj' -exec sed -i 's#<SpecificVersion>.*</SpecificVersion>#<SpecificVersion>True</SpecificVersion>#' {} + || die

	# bundled nuget is missing => use system nuget.
	sed -i 's|mono .nuget/NuGet.exe|nuget|g' Makefile* || die

	# fix for https://github.com/gentoo/dotnet/issues/42
	epatch "${FILESDIR}/6.0-aspnet-template-references-fix.patch"
	use gnome || epatch "${FILESDIR}/6.0-kill-gnome.patch"
	use qtcurve && epatch "${FILESDIR}/kill-qtcurve-warning.patch"

	# copy missing binaries
	mkdir -p "${S}"/external/cecil/Test/libs/nunit-2.5.10/ || die
	cp -fR "${T}"/NUnit-2.5.10.11092/bin/net-2.0/framework/* "${S}"/external/cecil/Test/libs/nunit-2.5.10/ || die

	default
}

src_configure() {
	# env vars are added as the fix for https://github.com/gentoo/dotnet/issues/29
	MCS=/usr/bin/dmcs CSC=/usr/bin/dmcs GMCS=/usr/bin/dmcs econf \
		--disable-update-mimedb \
		--disable-update-desktopdb \
		--enable-monoextensions \
		--enable-gnomeplatform \
		$(use_enable subversion) \
		$(use_enable git)
	# https://github.com/mrward/xdt/issues/4
	# Main.sln file is created on the fly during econf
	epatch -p2 "${FILESDIR}/mrward-xdt-issue-4.patch"
	# fix of https://github.com/gentoo/dotnet/issues/38
	sed -i -E -e 's#(EXE_PATH=")(.*)(/lib/monodevelop/bin/MonoDevelop.exe")#\1'${EPREFIX}'/usr\3#g' "${S}/monodevelop" || die
}

src_compile() {
	xbuild "${S}/external/libgit2sharp/Lib/CustomBuildTasks/CustomBuildTasks.csproj"
	cp "${S}/external/libgit2sharp/Lib/CustomBuildTasks/bin/Debug/CustomBuildTasks.dll" "${S}/external/libgit2sharp/Lib/CustomBuildTasks/"

	default
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
