# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit git-r3 python-single-r1 systemd

DESCRIPTION="HomeBrew Repeater protocol as used by DMR+, MMDVM and Brandmeister"
HOMEPAGE="https://github.com/n0mjs710/HBlink"
EGIT_REPO_URI="https://github.com/n0mjs710/HBlink.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="systemd"

PDEPEND="dev-python/bitstring["${PYTHON_USEDEP}"]
		dev-python/bitarray["${PYTHON_USEDEP}"]
		dev-python/twisted["${PYTHON_USEDEP}"]
		net-misc/dmr_utils["${PYTHON_USEDEP}"]"

src_prepare() {
	rm -r retired || die
	sed -i "s#/opt/HBlink#/usr/share/${PN}#" systemd/*.service
	default
}

src_install() {
	if use systemd; then
		insinto "$(systemd_get_systemunitdir)"
		doins systemd/*.service
	fi
	rm -r systemd || die

	insinto /etc/hblink
	newins hblink-SAMPLE.cfg hblink.cfg

	insinto /usr/share/"${PN}"
	doins -r *
	python_fix_shebang "${ED}/usr/share/${PN}"
	ln -s /etc/hblink/hblink.cfg "${ED}"/usr/share/"${PN}"/hblink.cfg

	dodir /usr/bin
	for i in hb_bridge_all hb_confbridge
	do
		cat <<-EOF > "${ED}"/usr/bin/${i}
			#! /bin/sh
			cd /usr/share/${PN}
			python2 ./${i}.py "\$@"
		EOF
		fperms +x /usr/bin/${i}
	done
}
