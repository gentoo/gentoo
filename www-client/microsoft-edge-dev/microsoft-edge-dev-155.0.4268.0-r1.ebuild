# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit chromium-2 desktop pax-utils unpacker xdg

DESCRIPTION="The web browser from Microsoft"
HOMEPAGE="https://www.microsoft.com/edge"

if [[ ${PN} == microsoft-edge ]]; then
	MY_PN=${PN}-stable
else
	MY_PN=${PN}
fi

MY_P="${MY_PN}_${PV}-1"
SRC_URI="https://packages.microsoft.com/repos/edge/pool/main/m/${MY_PN}/${MY_P}_amd64.deb"
S=${WORKDIR}

LICENSE="microsoft-edge"
SLOT="0"
KEYWORDS="-* amd64"

IUSE="gtk3 +gtk4 qt6"
RESTRICT="bindist mirror strip"
REQUIRED_USE="|| ( gtk3 gtk4 )"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-fonts/liberation-fonts
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-misc/curl[ssl]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	x11-misc/xdg-utils
	gtk3? ( x11-libs/gtk+:3[X] )
	gtk4? ( gui-libs/gtk:4[X] )
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
"

QA_PREBUILT="*"
QA_DESKTOP_FILE="usr/share/applications/microsoft-edge.*\\.desktop"
EDGE_HOME="opt/microsoft/msedge${PN#microsoft-edge}"

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your tree before reporting a bug for microsoft-edge fetch failures."
}

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "microsoft-edge only works on amd64"
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	rm -f _gpgorigin || die

	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die

	# Microsoft Edge comes with its own bundled cron
	# scripts which invoke `apt` directly. Useless on Gentoo!
	rm -r etc/cron.daily || die "Failed to remove cron scripts"
	rm -r "${EDGE_HOME}"/cron || die "Failed to remove cron scripts"

	gzip -d usr/share/doc/${PF}/changelog.gz || die
	gzip -d usr/share/man/man1/${MY_PN}.1.gz || die
	if [[ -L usr/share/man/man1/${PN}.1.gz ]]; then
		rm usr/share/man/man1/${PN}.1.gz || die
		dosym ${MY_PN}.1 usr/share/man/man1/${PN}.1
	fi

	local size
	# channel suffix: "" stable, "_channel" for beta/dev.
	local channel=${PN#microsoft-edge}
	channel=${channel/-/_}
	for size in 16 24 32 48 64 128 256 ; do
		newicon -s ${size} "${EDGE_HOME}/product_logo_${size}${channel}.png" ${PN}.png
	done

	rm "${EDGE_HOME}/libqt5_shim.so" || die
	if ! use qt6; then
		rm "${EDGE_HOME}/libqt6_shim.so" || die
	fi

	pax-mark m "${EDGE_HOME}/msedge"

	# MS Edge includes channel information in the wrapper script, so rather than replace it like with Chromium,
	# We'll inject additional logic to look for and use user-defined flags in /etc/msedge/*.
	local wrapper="${ED}/${EDGE_HOME}/${PN}"
	local inject="${T}/msedge-wrapper-flags.inc"
	local wrapper_tmp="${T}/msedge-wrapper.new"

	cat > "${inject}" <<'EOF'

# Allow the user to override command-line flags, bug #357629.
for f in /etc/msedge/*; do
	case "${f}" in
		*~|*.bak|*.old|*.swp|*.tmp|*/.*) continue ;;
	esac
	[[ -f "${f}" ]] && source "${f}"
done

# Prefer user-defined MSEDGE_USER_FLAGS over MSEDGE_FLAGS from /etc/msedge/default.
MSEDGE_FLAGS=${MSEDGE_USER_FLAGS:-"$MSEDGE_FLAGS"}

EOF

	{
		# shebang and copyright notice; hasn't changed in 15 years.
		head -n 5 "${wrapper}" || die
		cat "${inject}" || die
		tail -n +7 "${wrapper}" | \
			sed 's|^exec -a "\$0" "\$HERE/msedge" "\$@"$|exec -a "$0" "$HERE/msedge" ${MSEDGE_FLAGS} "$@"|' || die
	} > "${wrapper_tmp}" || die "Failed to build wrapper with injected logic"

	cat "${wrapper_tmp}" > "${wrapper}" || die "Failed to update wrapper logic"
	rm -f "${wrapper_tmp}" || die "Failed to clean temporary wrapper"

	grep -q 'exec -a "\$0" "\$HERE/msedge" ${MSEDGE_FLAGS} "\$@"' "${wrapper}" ||
		die "Failed to update wrapper exec flags"
}

pkg_postinst() {
	if use gtk4 && has_version x11-libs/gtk+; then
		einfo "GTK4 has been selected, however x11-libs/gtk+ is also installed."
		einfo "MS Edge will prefer GTK3 at runtime as a result; if you prefer GTK4,"
		einfo "please create \`/etc/msedge/default\` and set \`MSEDGE_FLAGS=\"--gtk-version=4\"\`"
	fi
	xdg_desktop_database_update
	xdg_icon_cache_update
}
