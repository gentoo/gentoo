# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit fdo-mime gnome2-utils dotnet versionator eutils git-r3

DESCRIPTION="Integrated Development Environment for .NET"
HOMEPAGE="http://www.monodevelop.com/"
SRC_URI="https://launchpadlibrarian.net/68057829/NUnit-2.5.10.11092.zip
	https://www.nuget.org/api/v2/package/NUnit/2.6.3 -> NUnit.2.6.3.zip
	https://www.nuget.org/api/v2/package/NUnit.Runners/2.6.3  -> NUnit.Runners.2.6.3.zip
	https://www.nuget.org/api/v2/package/System.Web.Mvc.Extensions.Mvc.4/1.0.9 -> System.Web.Mvc.Extensions.Mvc.4.1.0.9.zip
	https://www.nuget.org/api/v2/package/Microsoft.AspNet.Mvc/5.2.2 -> Microsoft.AspNet.Mvc.5.2.2.zip
	https://www.nuget.org/api/v2/package/Microsoft.AspNet.Razor/3.2.2 -> Microsoft.AspNet.Razor.3.2.2.zip
	https://www.nuget.org/api/v2/package/Microsoft.AspNet.WebPages/3.2.2 -> Microsoft.AspNet.WebPages.3.2.2.zip
	https://www.nuget.org/api/v2/package/Microsoft.Web.Infrastructure/1.0.0.0 -> Microsoft.Web.Infrastructure.1.0.0.0.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+subversion +git +gnome qtcurve"

RDEPEND=">=dev-lang/mono-3.2.8
	>=dev-dotnet/nuget-2.8.3
	gnome? ( >=dev-dotnet/gnome-sharp-2.24.2-r1 )
	>=dev-dotnet/gtk-sharp-2.12.21:2
	>=www-servers/xsp-2
	dev-util/ctags
	sys-apps/dbus[X]
	subversion? ( dev-vcs/subversion )
	!<dev-util/monodevelop-boo-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-java-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-database-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-gdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-mdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-vala-$(get_version_component_range 1-2)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	x11-misc/shared-mime-info
	x11-terms/xterm
	app-arch/unzip"
MAKEOPTS="${MAKEOPTS} -j1" #nowarn
S="${WORKDIR}"/${P}
EGIT_REPO_URI="https://github.com/mono/monodevelop.git"
EGIT_COMMIT="${P}"

src_unpack() {
	cd "${T}"
	unpack NUnit-2.5.10.11092.zip

	#clone from git
	git-r3_fetch
	git-r3_checkout "${EGIT_REPO_URI}" "${T}/${P}"

	#extract packages
	mkdir -p "${T}"/packages || die
	cd "${T}"/packages || die

	for pkg in NUnit.2.6.3 \
				NUnit.Runners.2.6.3 \
				System.Web.Mvc.Extensions.Mvc.4.1.0.9 \
				Microsoft.AspNet.Mvc.5.2.2 \
				Microsoft.AspNet.Razor.3.2.2 \
				Microsoft.AspNet.WebPages.3.2.2 \
				Microsoft.Web.Infrastructure.1.0.0.0
	do
		mkdir $pkg || die
		cd $pkg || die
		unpack $pkg.zip
		cd .. || die
	done
	mkdir -p "${S}"
}

src_prepare() {
	# Remove the git rev-parse (changelog?)
	sed -i '/<Exec.*rev-parse/ d' "${T}/${P}/main/src/core/MonoDevelop.Core/MonoDevelop.Core.csproj" || die
	# Set specific_version to prevent binding problem
	# when gtk#-3 is installed alongside gtk#-2
	find "${T}/${P}" -name '*.csproj' -exec sed -i 's#<SpecificVersion>.*</SpecificVersion>#<SpecificVersion>True</SpecificVersion>#' {} + || die

	#fix ASP.Net
	cd "${T}/${P}/main"
	epatch "${FILESDIR}/5.7-downgrade_to_mvc3.patch"
	epatch "${FILESDIR}/local-nuget-icons.patch"

	# fix for https://github.com/gentoo/dotnet/issues/42
	epatch "${FILESDIR}/aspnet-template-references-fix.patch"
	use gnome || epatch "${FILESDIR}/5.9.5-kill-gnome.patch"
	use qtcurve && epatch "${FILESDIR}/kill-qtcurve-warning.patch"

	#prepare dist package
	cd "${T}/${P}"
	epatch "${FILESDIR}/5.9.5-skip_merged_tar.patch"
	./configure --profile=default || die
	make dist || die

	#move it
	mv -f "${T}/${P}/tarballs/"monodevelop-*/* "${S}" || die

	#copy missing binaries
	mkdir -p "${S}"/external/cecil/Test/libs/nunit-2.5.10/ || die
	cp -fR "${T}"/NUnit-2.5.10.11092/bin/net-2.0/framework/* "${S}"/external/cecil/Test/libs/nunit-2.5.10/ || die
	mv -f "${T}/packages" "${S}" || die

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
