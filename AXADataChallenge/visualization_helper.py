import matplotlib.pyplot as plt
import seaborn as sns

import numpy as np


def scatterplot_all(df, target, ncols=3, figsize=(15, 12), alpha=0.1):
    # Plot

    # Get all features to plot against target
    features = df.columns.drop(target)

    colors = ['#0055ff', '#ff7000', '#23bf00']
    sns.set_palette(sns.color_palette(colors))

    # Calculate required rows
    nrows = int(np.ceil(len(features) / 3))

    fig, ax = plt.subplots(nrows=nrows, ncols=ncols, figsize=figsize, dpi=200)

    # Ensure that ax is 2D
    if nrows == 1:
        ax = ax.reshape(-1, 1)

    for i in range(len(features)):
        x = i//ncols
        y = i % ncols

        sns.scatterplot(data=df, x=features[i], y=target, ax=ax[x, y], alpha=alpha)
        ax[x, y].set_title('{} vs. {}'.format(target, features[i]), size=15)
        ax[x, y].set_xlabel(features[i], size=12)
        ax[x, y].set_ylabel(target, size=12)
        ax[x, y].grid()

    return ax
