# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mercurial savedconfig

EHG_REPO_URI="https://hg.prosody.im/${PN}/"

DESCRIPTION="A collection of community-maintained modules for Prosody"
HOMEPAGE="https://modules.prosody.im"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="net-im/prosody"

src_prepare() {
	default

	# Exclude 'misc' folder from install, since it does not provide any modules.
	echo "# Remove all modules from this list, which you don't want to install." > prosody-modules.conf || die
	find * -maxdepth 0 -type d ! -name misc >> prosody-modules.conf || die

	use savedconfig && restore_config prosody-modules.conf
}

src_install() {
	insinto "/usr/$(get_libdir)/prosody/community-modules"
	while read prosody_module; do
		if ! [[ "${prosody_module}" = \#* ]]; then
			if [[ -f "${prosody_module}/README.markdown" ]]; then
				newdoc "${prosody_module}/README.markdown" "README.${prosody_module}"
				rm "${prosody_module}/README.markdown" || die
			fi

			doins -r "${prosody_module}"
		fi
	done <prosody-modules.conf

	save_config prosody-modules.conf

	einstalldocs
}

pkg_postinst() {
	savedconfig_pkg_postinst

	einfo "In order to use the community modules on an existing instance, you have to add"
	einfo "'/usr/$(get_libdir)/prosody/community-modules' into 'plugin_paths'"
	einfo "into your prosody configuration file '/etc/jabber/prosody.cfg.lua.'"
	einfo ""
	einfo "Example: plugin_paths = { \"/usr/$(get_libdir)/prosody/modules\","
	einfo "\"/usr/$(get_libdir)/prosody/community-modules\" };"
}
