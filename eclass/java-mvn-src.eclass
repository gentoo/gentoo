# Eclass for Java packages from bare sources exported by Maven
#
# Copyright (c) 2004-2011, Gentoo Foundation
#
# Licensed under the GNU General Public License, v2
#
# $Id$

inherit java-pkg-simple

# -----------------------------------------------------------------------------
# @eclass-begin
# @eclass-summary Eclass for Java packages from bare sources exported by Maven
#
# This class is intended to build pure Java packages from the sources exported
# from the source:jar goal of Maven 2. These archives contain bare Java source
# files, with no build instructions or additional resource files. They are
# unsuitable for packages that require resources besides compiled class files.
# The benefit is that for artifacts developed with Maven, these source files
# are often released together with binary packages, whereas the full build
# environment might be contained in some revision control system or not
# available at all.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @variable-external GROUP_ID
# @variable-default ${PN}
#
# The groupId of the artifact, in dotted notation.
# -----------------------------------------------------------------------------
: ${GROUP_ID:=${PN}}

# -----------------------------------------------------------------------------
# @variable-external ARTIFACT_ID
# @variable-default ${PN}
#
# The artifactId of the artifact.
# -----------------------------------------------------------------------------
: ${ARTIFACT_ID:=${PN}}

# -----------------------------------------------------------------------------
# @variable-external MAVEN2_REPOSITORIES
# @variable-default http://repo2.maven.org/maven2 http://download.java.net/maven/2
#
# The repositories to search for the artifacts. Must follow Maven2 layout.
# -----------------------------------------------------------------------------
: ${MAVEN2_REPOSITORIES:="http://repo2.maven.org/maven2 http://download.java.net/maven/2"}

# -----------------------------------------------------------------------------
# @variable-internal RELATIVE_SRC_URI
#
# The path of the source artifact relative to the root of the repository.
# Will be set by the eclass to follow Maven 2 repository layout.
# -----------------------------------------------------------------------------
RELATIVE_SRC_URI=${GROUP_ID//./\/}/${ARTIFACT_ID}/${PV}/${ARTIFACT_ID}-${PV}-sources.jar

# Look for source jar in all listed repositories
for repo in ${MAVEN2_REPOSITORIES}; do
	SRC_URI="${SRC_URI} ${repo}/${RELATIVE_SRC_URI}"
done
unset repo

# ------------------------------------------------------------------------------
# @eclass-end
# ------------------------------------------------------------------------------
