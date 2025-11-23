#!/bin/bash

# JabRef may need some custom options to work and look properly on certain
# systems. You can set them via the JABREF_OPTIONS environment variable.
#     -Dglass.gtk.uiScale=144dpi   scale up the UI to look better on high DPI displays
#     -Djdk.gtk.version=2          workaround for misbehaving menus, e.g. on i3wm
# You can for example run JabRef as follows:
#     JABREF_OPTIONS="-Dglass.gtk.uiScale=144dpi -Djdk.gtk.version=2" jabref

# This script has been created based on the instructions at
# https://devdocs.jabref.org/getting-into-the-code/guidelines-for-setting-up-a-local-workspace,
# the output of `./gradlew -d run` and the contents of build/scripts/JabRef in the build
# directory.

ROOT=/usr/share/jabref

exec java \
	--add-exports javafx.controls/com.sun.javafx.scene.control=org.controlsfx.controls \
	--add-exports org.controlsfx.controls/impl.org.controlsfx.skin=org.jabref \
	--add-exports javafx.graphics/com.sun.javafx.scene=org.controlsfx.controls \
	--add-exports javafx.graphics/com.sun.javafx.scene.traversal=org.controlsfx.controls \
	--add-exports javafx.graphics/com.sun.javafx.css=org.controlsfx.controls \
	--add-exports javafx.controls/com.sun.javafx.scene.control.behavior=org.controlsfx.controls \
	--add-exports javafx.controls/com.sun.javafx.scene.control.inputmap=org.controlsfx.controls \
	--add-exports javafx.base/com.sun.javafx.event=org.controlsfx.controls \
	--add-exports javafx.base/com.sun.javafx.collections=org.controlsfx.controls \
	--add-exports javafx.base/com.sun.javafx.runtime=org.controlsfx.controls \
	--add-exports javafx.web/com.sun.webkit=org.controlsfx.controls \
	--add-opens javafx.controls/javafx.scene.control=org.jabref \
	--add-opens org.controlsfx.controls/org.controlsfx.control.textfield=org.jabref \
	--add-opens javafx.controls/com.sun.javafx.scene.control=org.jabref \
	--add-opens javafx.controls/javafx.scene.control.skin=org.controlsfx.controls \
	--add-opens javafx.graphics/javafx.scene=org.controlsfx.controls \
	--module-path ${ROOT}/lib \
	--patch-module org.jabref=${ROOT}/resources/main \
	${JABREF_OPTIONS} \
	--module org.jabref/org.jabref.Launcher \
	"$@"
