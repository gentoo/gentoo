# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="Proprietary plugins and firmware for HPLIP"
HOMEPAGE="https://developers.hp.com/hp-linux-imaging-and-printing/plugins"
SRC_URI="https://developers.hp.com/sites/default/files/hplip-${PV}-plugin.run"
LICENSE="hplip-plugin"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="orblite"

RDEPEND="
	~net-print/hplip-${PV}
	virtual/udev
	orblite? (
		media-gfx/sane-backends
		>=sys-libs/glibc-2.26
		virtual/libusb:0
	)
"
DEPEND=""

S=${WORKDIR}

HPLIP_HOME=/usr/share/hplip

# Binary prebuilt package
QA_PREBUILT="${HPLIP_HOME}/*.so"

# License does not allow us to redistribute the "source" package
RESTRICT="mirror"

src_install() {
	local hplip_arch
	case "${ARCH}" in
		amd64) hplip_arch="x86_64" ;;
		arm)   hplip_arch="arm32"  ;;
		x86)   hplip_arch="x86_32" ;;
		*)     die "Unsupported architecture." ;;
	esac

	insinto "${HPLIP_HOME}"/data/firmware
	doins *.fw.gz

	for plugin in *-${hplip_arch}.so; do
		local plugin_type=prnt
		case "${plugin}" in
			bb_orblite-*)
				use orblite || continue
				plugin_type=scan ;;
			bb_*)
				plugin_type=scan ;;
			fax_*)
				plugin_type=fax ;;
		esac

		exeinto "${HPLIP_HOME}"/${plugin_type}/plugins
		newexe ${plugin} ${plugin/-${hplip_arch}}
	done

	insinto /var/lib/hp
	newins - hplip.state <<-_EOF_
		[plugin]
		installed = 1
		eula = 1
		version = ${PV}
	_EOF_
}
