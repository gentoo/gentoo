# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="https://pypi.python.org/pypi/autobahn http://autobahn.ws/python/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.zip"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/snappy[${PYTHON_USEDEP}]
	dev-python/lz4[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/twisted-core[$(python_gen_usedep 'python2*')]
	dev-python/ujson[${PYTHON_USEDEP}]
	dev-python/wsaccel[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

# TWISTED_DISABLE_WRITING_OF_PLUGIN_CACHE is now
# set in make.defaults. so update the plugin cache

# copy of the twisted-r1 eclass cache update functions
# for the older split twisted releases

# @ECLASS-VARIABLE: TWISTED_PLUGINS
# @DESCRIPTION:
# An array of Twisted plugins, whose cache is regenerated
# in pkg_postinst() and pkg_postrm() phases.
#
# If no plugins are installed, set to empty array.
declare -p TWISTED_PLUGINS &>/dev/null || TWISTED_PLUGINS=( twisted.plugins )

# @FUNCTION: _twisted-r1_create_caches
# @USAGE: <packages>...
# @DESCRIPTION:
# Create dropin.cache for plugins in specified packages. The packages
# are to be listed in standard dotted Python syntax.
_twisted-r1_create_caches() {
	# http://twistedmatrix.com/documents/current/core/howto/plugin.html
	"${PYTHON}" -c \
"import sys
sys.path.insert(0, '${ROOT}$(python_get_sitedir)')

fail = False

try:
	from twisted.plugin import getPlugins, IPlugin
except ImportError as e:
	if '${EBUILD_PHASE}' == 'postinst':
		raise
else:
	for module in sys.argv[1:]:
		try:
			__import__(module, globals())
		except ImportError as e:
			if '${EBUILD_PHASE}' == 'postinst':
				raise
		else:
			list(getPlugins(IPlugin, sys.modules[module]))
" \
		"${@}" || die "twisted plugin cache update failed"
}

# @FUNCTION: twisted-r1_update_plugin_cache
# @DESCRIPTION:
# Update and clean up plugin caches for packages listed
# in TWISTED_PLUGINS.
twisted-r1_update_plugin_cache() {
	[[ ${TWISTED_PLUGINS[@]} ]] || return

	local subdirs=( "${TWISTED_PLUGINS[@]//.//}" )
	local paths=( "${subdirs[@]/#/${ROOT}$(python_get_sitedir)/}" )
	local caches=( "${paths[@]/%//dropin.cache}" )

	# First, delete existing (possibly stray) caches.
	rm -f "${caches[@]}" || die

	# Now, let's see which ones we can regenerate.
	_twisted-r1_create_caches "${TWISTED_PLUGINS[@]}"

	# Finally, drop empty parent directories.
	rmdir -p "${paths[@]}" 2>/dev/null
}

pkg_postinst() {
	_distutils-r1_run_foreach_impl twisted-r1_update_plugin_cache
}

pkg_postrm() {
	_distutils-r1_run_foreach_impl twisted-r1_update_plugin_cache
}
