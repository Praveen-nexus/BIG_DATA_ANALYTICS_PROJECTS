## FAKE NEWS PREDICTION PROJECT


```python

```


```python
# Libraries and Loading data
```


```python
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

from datetime import datetime
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
from prettytable import PrettyTable
```


```python
pd.set_option("display.max_columns", 100)
pd.set_option("display.max_colwidth", 100)
pd.set_option("display.max_info_columns", 100)
pd.set_option('display.max_colwidth', None)  # Set option to display full content of columns
```


```python
path = r"fake_real_news.csv"
data = pd.read_csv(path)
```


```python
data.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 4594 entries, 0 to 4593
    Data columns (total 4 columns):
     #   Column  Non-Null Count  Dtype 
    ---  ------  --------------  ----- 
     0   title   4593 non-null   object
     1   text    4594 non-null   object
     2   idd     4594 non-null   object
     3   label   4594 non-null   object
    dtypes: object(4)
    memory usage: 143.7+ KB
    


```python
data.nunique()
```




    title    4537
    text     4409
    idd      4594
    label       2
    dtype: int64




```python
# data.head(5)
data.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>title</th>
      <th>text</th>
      <th>idd</th>
      <th>label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>‘A target on Roe v. Wade ’: Oklahoma bill making it a felony to perform abortions waits for governor’s decision</td>
      <td>UPDATE: Gov. Fallin vetoed the bill on Friday. Head here for more.\n\nLawmakers in Oklahoma approved a bill Thursday that would make performing abortions a felony and revoke the medical licenses of most physicians who assist in such procedures.\n\nThis sweeping measure, which opponents described as unconstitutional and unprecedented, now heads to Gov. Mary Fallin (R). She will have five days — not including Sunday — to decide whether to sign the bill, veto it or allow it to become law without her signature, according to a spokesman.\n\n“The governor will withhold comment on that bill, as she does on most bills, until she and her staff have had a chance to review it,” Michael McNutt, a spokesman for Fallin, said in an email.\n\nThe Oklahoma bill is the first such measure of its kind, according to the Center for Reproductive Rights, which says that other states seeking to ban abortion have simply banned the procedure rather than attaching penalties like this.\n\nAccording to the measure, known as SB1552, a person who performs or induces an abortion will be guilty of a felony and punished with between one and three years in the state penitentiary.\n\nThis legislation also says that any physician who participates in an abortion — deemed “unprofessional conduct” in the bill — will be “prohibited from obtaining or renewing a license to practice medicine in this state.” However, medical licenses will not be stripped from doctors who perform abortions deemed necessary to save the mother’s life.\n\n[Yes, hospitals perform abortions. This D.C. doctor says her hospital won’t let her talk about it]\n\nThe bill passed the Oklahoma House of Representatives with a vote of 59-to-9 last month. On Thursday, the state’s senate passed it with a vote of 33-to-12.\n\n“Since I believe life begins at conception, it should be protected, and I believe it’s a core function of state government to defend that life from the beginning of conception,” State Sen. Nathan Dahm, a Republican who represents Tulsa County, told the Associated Press.\n\nDahm said he hopes the Oklahoma measure could eventually lead to the overturning of Roe v. Wade, the 1973 Supreme Court decision that recognized a woman’s right to an abortion. Dahm did not respond to messages seeking comment Thursday and Friday.\n\nDawn Laguens, executive vice president of Planned Parenthood Federation of America,  said last month that the Oklahoma bill is “a ban on abortion, plain and simple.” The legislation sent to Fallin on Thursday “is reckless and dangerous,” according to Ilyse Hogue, president of NARAL Pro-Choice America.\n\n“This bill puts doctors in the cross hairs for providing women with the option of exercising our fundamental right to decide how and when to start a family,” Hogue said in a statement. “And it creates penalties for doctors doing their jobs: performing a safe and legal medical procedure.”\n\nLiberty Counsel, a group that rose to national prominence last year defending the Kentucky clerk who refused to sign same-sex marriage licenses, said Friday that it had helped support the legislation in Oklahoma. The organization also vowed to defend it in court.\n\n“This particular bill puts a target on Roe v. Wade,” Mat Staver, the group’s founder and chairman, said in an interview Friday. “It is Oklahoma’s line in the sand on the sanctity of human life, as standing on the side of protecting innocent children.”\n\nStaver said that his group met with Oklahoma lawmakers before the legislation was filed, offering legal analysis after discussions had begun in the state about proposing such a measure.\n\nThe Oklahoma bill is “the first of its kind,” Staver said, though he said it was possible other states may follow Oklahoma’s lead.\n\n“This is a bolt step in the right direction, in my view,” Staver said. “It will be challenged and we’re prepared to defend it.”\n\n[Oklahoma isn’t the only state taking big steps to limit abortions]\n\nThe Oklahoma State Medical Association, which has called the measure “troubling,” has said it would not take a position on the legality of abortion as long as the practice remains legal. However, the group said it was opposed to “legislation that is designed to intimidate physicians or override their medical judgment.”\n\nOn Thursday, the group reiterated that opposition, calling it “one more insulting slap in the face of our state’s medical providers” and urging Fallin to veto the legislation.\n\n“We are extremely disappointed in today’s vote,” Sherri Baker, president of the medical association, said in a statement Thursday. “It is simply unconscionable that, at a time when our state already faces a severe physician shortage, the senate would waste its time on a bill that is patently unconstitutional and whose only purposes are to score political points and intimidate physicians across this state.”\n\nWhen the measure was debated in the state’s House of Representatives, a legislator who ultimately voted against the bill pointed to the group’s opposition and voiced concerns that the law could lead to doctors abandoning Oklahoma. But one of the bill’s co-sponsors said he did not think it would have an impact.\n\nSince taking office in 2011, Fallin has signed more than a dozen bills restricting access to reproductive health care, the Center for Reproductive Rights, a nonprofit legal group, said Thursday.\n\nThe new bill “is blatantly unconstitutional and, if it takes effect, it will be the most extreme abortion law in this country” since the Roe v. Wade decision, Amanda Allen, senior state legislative counsel at the center, wrote in a letter to Fallin on Thursday.\n\nAllen said her group was urging Fallin to veto the legislation, which she said was part of a larger pattern of lawmakers in the state chipping away at abortion rights.\n\n“Policymakers in Oklahoma should focus on advancing policies that will truly promote women’s health and safety, not abortion restrictions that do just the opposite,” Allen wrote. “Anti-choice politicians in the state have methodically restricted access to abortion and neglected to advance policies that truly address the challenges women and families face every day.”\n\nAllen also said that the bill would “almost certainly lead to expensive court challenges that the state of Oklahoma simply cannot defend in light of longstanding Supreme Court precedent.”\n\nFallin has until next week to make a decision on the bill. If this measure does become law, it would go into effect on Nov. 1.\n\nThe forgotten history of Justice Ginsburg’s criticism of Roe v. Wade\n\nIndiana banned abortions if fetuses have Down syndrome\n\nThis story, first published on Thursday, has been updated on Friday to include Liberty Counsel’s comments.</td>
      <td>Fq+C96tcx+</td>
      <td>REAL</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Study: women had to drive 4 times farther after Texas laws closed abortion clinics</td>
      <td>Ever since Texas laws closed about half of the state's abortion clinics in 2013, researchers have been trying to understand just how much burden those laws place on women who are trying to access abortion. That's important because the Supreme Court is now considering those laws as part of Whole Woman's Health v. Hellerstedt, the court's most consequential abortion case in decades. If it finds that the laws place an "undue burden" on women, they'll likely be struck down.\n\nResearchers with the Texas Policy Evaluation Project (TxPEP), looking into exactly that, have already found that some women had to wait as much as three weeks longer for an appointment. Some women they've interviewed weren't able to secure an abortion at all, due to the logistical and financial barriers.\n\nNow, TxPEP has published a significant study, in the American Journal of Public Health, on the effects of HB2, the omnibus anti-abortion bill that the Court could end up partially striking down. The study shows just how many burdens were placed on women as a result of the clinics closed by the law.\n\nResearchers surveyed 398 Texas women, comparing women whose nearest abortion clinic was closed in mid-2014 with those whose nearest clinic was still open in April 2013, shortly before the Texas legislature debated HB2.\n\nThe results were striking. Of the women surveyed, 38 percent lived in a zip code where the closest clinic was open in 2013 but closed in 2014.\n\nOne key finding: Women whose nearest clinic hadn't closed had to travel an average of 22 miles, while women whose nearest clinic had closed traveled an average of 85 miles — almost four times as far. And a quarter of women in the latter group had to travel more than 139 miles to get an abortion.\n\nThis was the case even six months after HB2 went into effect, when abortion providers would have had at least some time to adjust to the initial chaos of closures.\n\nWomen whose nearest clinics closed had a tougher time by just about every measure: They had to travel farther and pay more out of pocket for things like gas, hotels, and child care.\n\nThey were less likely to be able to access medication abortion instead of surgical abortion if they wanted it — probably because Texas law requires four different doctors' visits for medication abortion, which is a lot tougher to manage when you live far away.\n\nUnsurprisingly, they were also more likely to report that it was "somewhat hard" or "very hard" to get care.\n\nWomen whose nearest clinics closed also faced more burdens — for instance, they were more likely to both travel more than 50 miles and spend more than $100 on the trip. Twenty-four percent of women in the closure group reported facing three or more different kinds of burdens, compared to just 4 percent of women whose clinics remained open.\n\nAnd the study only looked at women who eventually got their desired abortion — so it couldn't account for the women who weren't able to get one at all because the burdens were too high.\n\n"This study is unusual in its ability to assess multiple burdens imposed on women as a result of clinic closures, but it is important to note that the burdens documented here are not the only hardships that women experienced as a result of HB2," said study author Liza Fuentes in a statement.\n\nStrangely, there was no significant difference between the two groups of women in how far along they were in their pregnancy when they had an abortion. That's inconsistent with other TxPEP research that found, after HB2 passed, a small but significant increase in second-trimester abortion procedures, which are not quite as safe and a lot more expensive compared to the first trimester procedures.\n\nBut that could be explained by a couple of things, the researchers wrote. Either the long wait times forced by HB2 are affecting everyone equally, or the differences were too small to show up in this study.\n\nIt's still clear, the researchers said, that the clinic closures after HB2 passed "resulted in significant burdens for women able to obtain care."</td>
      <td>bHUqK!pgmv</td>
      <td>REAL</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Trump, Clinton clash in dueling DC speeches</td>
      <td>Donald Trump and Hillary Clinton, now at the starting line of a general election race, traded shots across the capital Friday in dueling addresses before two very different D.C. audiences -- each warning the other would take the country backward.\n\nTrump headlined the Faith and Freedom Coalition’s “Road to Majority” summit while Clinton addressed a Planned Parenthood national conference.\n\nTrump, looking to solidify his standing with evangelical Christians, offered assurances Friday that he would “restore respect for people of faith” -- and stressed the “sanctity and dignity of life.”\n\nIf there was any doubt he wanted to throw Clinton's Planned Parenthood speech into sharp relief, he took on his presumptive rival later in his remarks. Trump warned Clinton would "appoint radical judges," eliminate the Second Amendment, "restrict religious freedom with government mandates," and "push for federal funding of abortion on demand up until the moment of birth."\n\nHe also cast her support for bringing in Syrian refugees as a potential clash of faiths. "Hillary will bring hundreds of thousands of refugees, many of whom have hostile beliefs about people of different faiths and values," he said.\n\nClinton, meanwhile, in her first speech as the Democratic Party’s presumptive nominee, said a Trump presidency would take the country back to a time “when abortion was illegal … and life for too many women and girls was limited.”\n\nClinton thanked the nonprofit women’s health group and abortion provider for their support in the Democratic primary race. In January, Planned Parenthood backed Clinton, offering its first-ever primary endorsement in the group’s 100-year history.\n\nClinton made it clear that women’s issues would be a staple of her campaign, promising abortion rights supporters that she would “always have your back” if elected president.\n\nClinton repeated claims that Trump wants to “take America back to a time when women had less opportunity” and freedom.\n\n“Well, Donald, those days are over. We are not going to let Donald Trump -- or anybody else -- turn back the clock,” she told the cheering crowd.\n\nBefore arriving at the event, Clinton held a private meeting at her D.C. home with Massachusetts Sen. Elizabeth Warren, who has been rumored to be a consideration for running mate.\n\nEchoing some of the attacks Warren has made in recent days, Clinton attempted to elevate the importance of this election.\n\n“We are in the middle of a concerted, persistent assault on women’s health across the country,” warned Clinton, who said the 2016 election was “profoundly different” than previous elections.\n\nIn what is a campaign trail staple of hers, Clinton highlighted Trump’s insults toward women and asserted that it would be “hard to imagine depending on him to defend the fundamental rights of women.”\n\nTrump, meanwhile, continued calling Clinton, “crooked Hillary” and referred to her ongoing email scandal. He took her to task on her domestic and foreign policy stances.\n\nTrump was interrupted by protesters at the annual gathering of evangelical Christians. The protesters shouted “Stop hate! Stop Trump!” and “refugees are welcome here.”\n\nTrump called the chants “a little freedom of speech” but added it was also “a little rude, but what can you do?”</td>
      <td>4Y4Ubf%aTi</td>
      <td>REAL</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Grand jury in Texas indicts activists behind Planned Parenthood videos</td>
      <td>A Houston grand jury investigating criminal allegations against Planned Parenthood stemming from a series of undercover videos on Monday instead indicted two of the anti-abortion activists who shot the footage.\n\nIn a stunning turn of events, the grand jury declined to indict officials from the abortion provider, and instead handed up a felony charges of tampering with a government record against Center for Medical Progress founder David Daleiden and center employee Sandra Merritt. Daleidon was also charged with a misdemeanor count related to purchasing human organs.\n\n"We were called upon to investigate allegations of criminal conduct by Planned Parenthood Gulf Coast," Harris County District Attorney Devon Anderson said. "As I stated at the outset of this investigation, we must go where the evidence leads us. All the evidence uncovered in the course of this investigation was presented to the grand jury. I respect their decision on this difficult case."\n\nThe case sprang from a series of dramatic undercover videos in which Center for Medical Progress employees posed as prospective buyers of fetal tissue, and captured several employees of Planned Parenthood and its contractors appearing to discuss practices banned by law. However, when the videos were released online last year, Planned Parenthood claimed selective editing had created a misperception.\n\nAnderson didn't provide details on the charges, including what record or records were allegedly tampered with and why Daleiden faces a charge related to buying human organs. Anderson's office said it could not provide details until the documents charging Daleiden and Merritt were formally made public.\n\n"The Center for Medical Progress uses the same undercover techniques that investigative journalists have used for decades in exercising our First Amendment rights to freedom of speech and of the press, and follows all applicable laws," Daleiden said in a statement in response to the indictment.\n\n"We respect the processes of the Harris County District Attorney, and note that buying fetal tissue requires a seller as well. Planned Parenthood still cannot deny the admissions from their leadership about fetal organ sales captured on video for all the world to see," the statement continued.\n\n"These anti-abortion extremists spent three years creating a fake company, creating fake identities, lying, and breaking the law. When they couldn't find any improper or illegal activity, they made it up," Eric Ferrero, vice president of communications for Planned Parenthood Federation of America, said in a statement.\n\n“As the dust settles and the truth comes out, it's become totally clear that the only people who engaged in wrongdoing are the criminals behind this fraud, and we're glad they're being held accountable,” Ferrero said.\n\nThe videos, some of which were shot in Texas, riled anti-abortion activists and prompted Republicans in Congress last summer to unsuccessfully called for cutting off funding for the organization.\n\nTexas Gov. Greg Abbott, a Republican, has called footage from the Planned Parenthood clinic in Houston "repulsive and unconscionable." It showed people pretending to be from a company that procures fetal tissue for research touring the facility. Texas Attorney General Ken Paxton also opened his own investigation into the videos.\n\nAbbott said the indictments will not impact the state's investigation\n\n“The State of Texas will continue to protect life, and I will continue to support legislation prohibiting the sale or transfer of fetal tissue,” he said in a statement.\n\nRep. Diane Black, R-Tenn., author of the House-passed "Defund Planned Parenthood Act of 2015," said the she was “profoundly disappointed” in the indictments.\n\n“It is a sad day in America when those who harvest the body parts of aborted babies escape consequences for their actions, while the courageous truth-tellers who expose their misdeeds are handed down a politically motivated indictment instead,” she said.\n\nPlanned Parenthood says it abides by a law that allows providers to be reimbursed for the costs of processing tissue donated by women who have had abortions.\n\nThe Texas video was the fifth released by the group. Before its release, Melaney Linton, president of the Houston Planned Parenthood clinic, told state lawmakers last summer that it was likely to feature actors — pretending to be from a company called BioMax — asking leading questions about how to select potential donors for a supposed study of sickle cell anemia.\n\nLinton said the footage could feature several interactions initiated by BioMax about how and whether a doctor could adjust an abortion if the patient has offered to donate tissue for medical research. She also said Planned Parenthood believed the video would be manipulated.\n\nEarlier this month, Planned Parenthood sued the center in a California federal court, alleging extensive criminal misconduct. The lawsuit says the center's videos were the result of numerous illegalities, including making recordings without consent, registering false identities with state agencies and violating non-disclosure agreements.\n\nAfter the lawsuit was filed, Daleiden told The Associated Press that he looked forward to confronting Planned Parenthood in court.\n\nThe Associated Press contributed to this report.</td>
      <td>_CoY89SJ@K</td>
      <td>REAL</td>
    </tr>
    <tr>
      <th>4</th>
      <td>As Reproductive Rights Hang In The Balance, Debate Moderators Drop The Ball</td>
      <td>WASHINGTON -- Forty-three years after the Supreme Court established the right to a safe and legal abortion in Roe v. Wade, the stakes have never been higher for those on both sides of the abortion debate. States have enacted 288 new abortion restrictions in the past five years that have shut down a slew of clinics across the country, and the next president could nominate Supreme Court justices who will determine the fate of legal abortion for decades to come.\n\nBut even as abortion access for millions of women hangs in the balance, the issue has somehow been neglected by presidential debate moderators, causing the issue of reproductive rights to fade from the 2016 race. The Democratic candidates haven't been asked about reproductive rights at all in any of their four debates, and the Republicans have only been asked about abortion and funding for Planned Parenthood in the first two of the six debates they've participated in so far.\n\nAdvocates working for and against abortion rights are baffled by the silence.\n\n“There are real and important differences between candidates here, and it's a loss for American women that they haven't been explored,” said Jess McIntosh, a spokeswoman for EMILY’s List, a group that helps elect pro-choice women to office.\n\nNBC moderators did not ask how Sen. Bernie Sanders’ (I-Vt.) new health plan, released just two hours before the Democratic debate the network hosted Sunday, would handle public funding for abortion, and did not press Hillary Clinton on her view that federal restrictions on Medicaid funding for abortion should be repealed. Sens. Marco Rubio (R-Fla.) and Ted Cruz (R-Texas) haven't been asked in the past four GOP debates about their opposition to allowing victims of rape or incest to get abortions, a position that is significantly more conservative than those held by prior Republican presidential nominees.\n\nThe only abortion-related question GOP frontrunner Donald Trump has fielded during a debate was back in August, when Fox's Megyn Kelly asked him about his 1999 comment that he was "very pro-choice." His stance on abortion is much murkier these days, but no other moderators have chosen to ask him about it.\n\nAmericans United for Life, an anti-abortion group, wants candidates on both sides to explain whether they support public funding for abortion or the kinds of clinic regulations that conservative states have passed to make it difficult for abortion providers to stay open.\n\n“Pro-life Americans would love to know whether candidates support health and safety standards for women who are exposed to great risks in abortion clinics,” said Kristi Hamrick, a spokeswoman for AUL.</td>
      <td>+rJHoRQVLe</td>
      <td>REAL</td>
    </tr>
  </tbody>
</table>
</div>



# Plots and data exploration


```python
#creating a count plot for category column
fig = plt.figure(figsize=(10,5))

graph = sns.countplot(x="label", data=data)
plt.title("Count of Fake and True News")

#removing boundary
graph.spines["right"].set_visible(False)
graph.spines["top"].set_visible(False)
graph.spines["left"].set_visible(False)

#annoting bars with the counts  
for p in graph.patches:
        height = p.get_height()
        graph.text(p.get_x()+p.get_width()/2., height + 0.2,height ,ha="center",fontsize=12)
```

    c:\Users\Source\.conda\envs\py\Lib\site-packages\seaborn\_oldcore.py:1498: FutureWarning: is_categorical_dtype is deprecated and will be removed in a future version. Use isinstance(dtype, CategoricalDtype) instead
      if pd.api.types.is_categorical_dtype(vector):
    c:\Users\Source\.conda\envs\py\Lib\site-packages\seaborn\_oldcore.py:1498: FutureWarning: is_categorical_dtype is deprecated and will be removed in a future version. Use isinstance(dtype, CategoricalDtype) instead
      if pd.api.types.is_categorical_dtype(vector):
    c:\Users\Source\.conda\envs\py\Lib\site-packages\seaborn\_oldcore.py:1498: FutureWarning: is_categorical_dtype is deprecated and will be removed in a future version. Use isinstance(dtype, CategoricalDtype) instead
      if pd.api.types.is_categorical_dtype(vector):
    


    
![png](output_10_1.png)
    


# Data cleaning


```python
import spacy
import re
import nltk

from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import word_tokenize
```


```python
pd.DataFrame({'Type':data.dtypes, 'Missing':data.isna().sum(), "Cnt_unique":data.nunique()})
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Type</th>
      <th>Missing</th>
      <th>Cnt_unique</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>title</th>
      <td>object</td>
      <td>1</td>
      <td>4537</td>
    </tr>
    <tr>
      <th>text</th>
      <td>object</td>
      <td>0</td>
      <td>4409</td>
    </tr>
    <tr>
      <th>idd</th>
      <td>object</td>
      <td>0</td>
      <td>4594</td>
    </tr>
    <tr>
      <th>label</th>
      <td>object</td>
      <td>0</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.shape
```




    (4594, 4)




```python
# Assuming 'data' is your DataFrame
null_title = data[data['title'].isnull()]

null_title
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>title</th>
      <th>text</th>
      <th>idd</th>
      <th>label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>988</th>
      <td>NaN</td>
      <td>A verdict in 2017 could have sweeping consequences for tech startups.</td>
      <td>jCmY+5Vy_D</td>
      <td>REAL</td>
    </tr>
  </tbody>
</table>
</div>




```python
data['title'].fillna('Tech Startup Verdict', inplace=True)
```


```python
#instead of dropping these values we are going to merge title with text

data["text"] =data["title"]+"_"+data["text"]

#we only need two columns rest can be ignored

data=data[["text","label"]]
```


```python
#checking if there is empty string in TEXT column
blanks=[]

#index,label and review of the doc
for index,text in data["text"].items(): # it will iter through index,label and review
    if text.isspace(): # if there is a space
        blanks.append(index) #it will be noted down in empty list

len(blanks)
```




    0




```python
data.head(2)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>text</th>
      <th>label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>‘A target on Roe v. Wade ’: Oklahoma bill making it a felony to perform abortions waits for governor’s decision_UPDATE: Gov. Fallin vetoed the bill on Friday. Head here for more.\n\nLawmakers in Oklahoma approved a bill Thursday that would make performing abortions a felony and revoke the medical licenses of most physicians who assist in such procedures.\n\nThis sweeping measure, which opponents described as unconstitutional and unprecedented, now heads to Gov. Mary Fallin (R). She will have five days — not including Sunday — to decide whether to sign the bill, veto it or allow it to become law without her signature, according to a spokesman.\n\n“The governor will withhold comment on that bill, as she does on most bills, until she and her staff have had a chance to review it,” Michael McNutt, a spokesman for Fallin, said in an email.\n\nThe Oklahoma bill is the first such measure of its kind, according to the Center for Reproductive Rights, which says that other states seeking to ban abortion have simply banned the procedure rather than attaching penalties like this.\n\nAccording to the measure, known as SB1552, a person who performs or induces an abortion will be guilty of a felony and punished with between one and three years in the state penitentiary.\n\nThis legislation also says that any physician who participates in an abortion — deemed “unprofessional conduct” in the bill — will be “prohibited from obtaining or renewing a license to practice medicine in this state.” However, medical licenses will not be stripped from doctors who perform abortions deemed necessary to save the mother’s life.\n\n[Yes, hospitals perform abortions. This D.C. doctor says her hospital won’t let her talk about it]\n\nThe bill passed the Oklahoma House of Representatives with a vote of 59-to-9 last month. On Thursday, the state’s senate passed it with a vote of 33-to-12.\n\n“Since I believe life begins at conception, it should be protected, and I believe it’s a core function of state government to defend that life from the beginning of conception,” State Sen. Nathan Dahm, a Republican who represents Tulsa County, told the Associated Press.\n\nDahm said he hopes the Oklahoma measure could eventually lead to the overturning of Roe v. Wade, the 1973 Supreme Court decision that recognized a woman’s right to an abortion. Dahm did not respond to messages seeking comment Thursday and Friday.\n\nDawn Laguens, executive vice president of Planned Parenthood Federation of America,  said last month that the Oklahoma bill is “a ban on abortion, plain and simple.” The legislation sent to Fallin on Thursday “is reckless and dangerous,” according to Ilyse Hogue, president of NARAL Pro-Choice America.\n\n“This bill puts doctors in the cross hairs for providing women with the option of exercising our fundamental right to decide how and when to start a family,” Hogue said in a statement. “And it creates penalties for doctors doing their jobs: performing a safe and legal medical procedure.”\n\nLiberty Counsel, a group that rose to national prominence last year defending the Kentucky clerk who refused to sign same-sex marriage licenses, said Friday that it had helped support the legislation in Oklahoma. The organization also vowed to defend it in court.\n\n“This particular bill puts a target on Roe v. Wade,” Mat Staver, the group’s founder and chairman, said in an interview Friday. “It is Oklahoma’s line in the sand on the sanctity of human life, as standing on the side of protecting innocent children.”\n\nStaver said that his group met with Oklahoma lawmakers before the legislation was filed, offering legal analysis after discussions had begun in the state about proposing such a measure.\n\nThe Oklahoma bill is “the first of its kind,” Staver said, though he said it was possible other states may follow Oklahoma’s lead.\n\n“This is a bolt step in the right direction, in my view,” Staver said. “It will be challenged and we’re prepared to defend it.”\n\n[Oklahoma isn’t the only state taking big steps to limit abortions]\n\nThe Oklahoma State Medical Association, which has called the measure “troubling,” has said it would not take a position on the legality of abortion as long as the practice remains legal. However, the group said it was opposed to “legislation that is designed to intimidate physicians or override their medical judgment.”\n\nOn Thursday, the group reiterated that opposition, calling it “one more insulting slap in the face of our state’s medical providers” and urging Fallin to veto the legislation.\n\n“We are extremely disappointed in today’s vote,” Sherri Baker, president of the medical association, said in a statement Thursday. “It is simply unconscionable that, at a time when our state already faces a severe physician shortage, the senate would waste its time on a bill that is patently unconstitutional and whose only purposes are to score political points and intimidate physicians across this state.”\n\nWhen the measure was debated in the state’s House of Representatives, a legislator who ultimately voted against the bill pointed to the group’s opposition and voiced concerns that the law could lead to doctors abandoning Oklahoma. But one of the bill’s co-sponsors said he did not think it would have an impact.\n\nSince taking office in 2011, Fallin has signed more than a dozen bills restricting access to reproductive health care, the Center for Reproductive Rights, a nonprofit legal group, said Thursday.\n\nThe new bill “is blatantly unconstitutional and, if it takes effect, it will be the most extreme abortion law in this country” since the Roe v. Wade decision, Amanda Allen, senior state legislative counsel at the center, wrote in a letter to Fallin on Thursday.\n\nAllen said her group was urging Fallin to veto the legislation, which she said was part of a larger pattern of lawmakers in the state chipping away at abortion rights.\n\n“Policymakers in Oklahoma should focus on advancing policies that will truly promote women’s health and safety, not abortion restrictions that do just the opposite,” Allen wrote. “Anti-choice politicians in the state have methodically restricted access to abortion and neglected to advance policies that truly address the challenges women and families face every day.”\n\nAllen also said that the bill would “almost certainly lead to expensive court challenges that the state of Oklahoma simply cannot defend in light of longstanding Supreme Court precedent.”\n\nFallin has until next week to make a decision on the bill. If this measure does become law, it would go into effect on Nov. 1.\n\nThe forgotten history of Justice Ginsburg’s criticism of Roe v. Wade\n\nIndiana banned abortions if fetuses have Down syndrome\n\nThis story, first published on Thursday, has been updated on Friday to include Liberty Counsel’s comments.</td>
      <td>REAL</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Study: women had to drive 4 times farther after Texas laws closed abortion clinics_Ever since Texas laws closed about half of the state's abortion clinics in 2013, researchers have been trying to understand just how much burden those laws place on women who are trying to access abortion. That's important because the Supreme Court is now considering those laws as part of Whole Woman's Health v. Hellerstedt, the court's most consequential abortion case in decades. If it finds that the laws place an "undue burden" on women, they'll likely be struck down.\n\nResearchers with the Texas Policy Evaluation Project (TxPEP), looking into exactly that, have already found that some women had to wait as much as three weeks longer for an appointment. Some women they've interviewed weren't able to secure an abortion at all, due to the logistical and financial barriers.\n\nNow, TxPEP has published a significant study, in the American Journal of Public Health, on the effects of HB2, the omnibus anti-abortion bill that the Court could end up partially striking down. The study shows just how many burdens were placed on women as a result of the clinics closed by the law.\n\nResearchers surveyed 398 Texas women, comparing women whose nearest abortion clinic was closed in mid-2014 with those whose nearest clinic was still open in April 2013, shortly before the Texas legislature debated HB2.\n\nThe results were striking. Of the women surveyed, 38 percent lived in a zip code where the closest clinic was open in 2013 but closed in 2014.\n\nOne key finding: Women whose nearest clinic hadn't closed had to travel an average of 22 miles, while women whose nearest clinic had closed traveled an average of 85 miles — almost four times as far. And a quarter of women in the latter group had to travel more than 139 miles to get an abortion.\n\nThis was the case even six months after HB2 went into effect, when abortion providers would have had at least some time to adjust to the initial chaos of closures.\n\nWomen whose nearest clinics closed had a tougher time by just about every measure: They had to travel farther and pay more out of pocket for things like gas, hotels, and child care.\n\nThey were less likely to be able to access medication abortion instead of surgical abortion if they wanted it — probably because Texas law requires four different doctors' visits for medication abortion, which is a lot tougher to manage when you live far away.\n\nUnsurprisingly, they were also more likely to report that it was "somewhat hard" or "very hard" to get care.\n\nWomen whose nearest clinics closed also faced more burdens — for instance, they were more likely to both travel more than 50 miles and spend more than $100 on the trip. Twenty-four percent of women in the closure group reported facing three or more different kinds of burdens, compared to just 4 percent of women whose clinics remained open.\n\nAnd the study only looked at women who eventually got their desired abortion — so it couldn't account for the women who weren't able to get one at all because the burdens were too high.\n\n"This study is unusual in its ability to assess multiple burdens imposed on women as a result of clinic closures, but it is important to note that the burdens documented here are not the only hardships that women experienced as a result of HB2," said study author Liza Fuentes in a statement.\n\nStrangely, there was no significant difference between the two groups of women in how far along they were in their pregnancy when they had an abortion. That's inconsistent with other TxPEP research that found, after HB2 passed, a small but significant increase in second-trimester abortion procedures, which are not quite as safe and a lot more expensive compared to the first trimester procedures.\n\nBut that could be explained by a couple of things, the researchers wrote. Either the long wait times forced by HB2 are affecting everyone equally, or the differences were too small to show up in this study.\n\nIt's still clear, the researchers said, that the clinic closures after HB2 passed "resulted in significant burdens for women able to obtain care."</td>
      <td>REAL</td>
    </tr>
  </tbody>
</table>
</div>



# Tokenizing

#### spacy tokenized_text Takes too long to run


```python
#loading spacy library
nlp=spacy.load("en_core_web_sm")

#creating instance
lemma=WordNetLemmatizer()
```


```python
#creating list of stopwords containing stopwords from spacy and nltk

#stopwords of spacy
import nltk
nltk.download('stopwords')

list1=nlp.Defaults.stop_words
print(len(list1))

#stopwords of NLTK
list2=stopwords.words('english')
print(len(list2))

#combining the stopword list
Stopwords=set((set(list1)|set(list2)))
print(len(Stopwords))
```

    326
    179
    382
    

    [nltk_data] Downloading package stopwords to
    [nltk_data]     C:\Users\Source\AppData\Roaming\nltk_data...
    [nltk_data]   Package stopwords is already up-to-date!
    

# Pre Processing 1


```python
#text cleaning function
def clean_text(text):
    
    """
    It takes text as an input and clean it by applying several methods
    
    """
    
    string = ""
    
    #lower casing
    text=text.lower()
    
    #simplifying text
    text=re.sub(r"i'm","i am",text)
    text=re.sub(r"he's","he is",text)
    text=re.sub(r"she's","she is",text)
    text=re.sub(r"that's","that is",text)
    text=re.sub(r"what's","what is",text)
    text=re.sub(r"where's","where is",text)
    text=re.sub(r"\'ll"," will",text)
    text=re.sub(r"\'ve"," have",text)
    text=re.sub(r"\'re"," are",text)
    text=re.sub(r"\'d"," would",text)
    text=re.sub(r"won't","will not",text)
    text=re.sub(r"can't","cannot",text)
    
    #removing any special character
    text=re.sub(r"[-()\"#!@$%^&*{}?.,:]"," ",text)
    text=re.sub(r"\s+"," ",text)
    text=re.sub('[^A-Za-z0-9]+',' ', text)
    
    for word in text.split():
        if word not in Stopwords:
            string+=lemma.lemmatize(word)+" "
    
    return string
```


```python
import nltk
nltk.download('wordnet')
```

    [nltk_data] Downloading package wordnet to
    [nltk_data]     C:\Users\Source\AppData\Roaming\nltk_data...
    [nltk_data]   Package wordnet is already up-to-date!
    




    True




```python
#cleaning the whole data
data["text"]=data["text"].apply(clean_text)
```


```python

```


```python
data["text"]
```




    0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              target roe v wade oklahoma bill making felony perform abortion wait governor decision update gov fallin vetoed bill friday head lawmaker oklahoma approved bill thursday performing abortion felony revoke medical license physician assist procedure sweeping measure opponent described unconstitutional unprecedented head gov mary fallin r day including sunday decide sign bill veto allow law signature according spokesman governor withhold comment bill bill staff chance review michael mcnutt spokesman fallin said email oklahoma bill measure kind according center reproductive right say state seeking ban abortion simply banned procedure attaching penalty like according measure known sb1552 person performs induces abortion guilty felony punished year state penitentiary legislation say physician participates abortion deemed unprofessional conduct bill prohibited obtaining renewing license practice medicine state medical license stripped doctor perform abortion deemed necessary save mother life yes hospital perform abortion c doctor say hospital let talk bill passed oklahoma house representative vote 59 9 month thursday state senate passed vote 33 12 believe life begin conception protected believe core function state government defend life beginning conception state sen nathan dahm republican represents tulsa county told associated press dahm said hope oklahoma measure eventually lead overturning roe v wade 1973 supreme court decision recognized woman right abortion dahm respond message seeking comment thursday friday dawn laguens executive vice president planned parenthood federation america said month oklahoma bill ban abortion plain simple legislation sent fallin thursday reckless dangerous according ilyse hogue president naral pro choice america bill put doctor cross hair providing woman option exercising fundamental right decide start family hogue said statement creates penalty doctor job performing safe legal medical procedure liberty counsel group rose national prominence year defending kentucky clerk refused sign sex marriage license said friday helped support legislation oklahoma organization vowed defend court particular bill put target roe v wade mat staver group founder chairman said interview friday oklahoma line sand sanctity human life standing protecting innocent child staver said group met oklahoma lawmaker legislation filed offering legal analysis discussion begun state proposing measure oklahoma bill kind staver said said possible state follow oklahoma lead bolt step right direction view staver said challenged prepared defend oklahoma state taking big step limit abortion oklahoma state medical association called measure troubling said position legality abortion long practice remains legal group said opposed legislation designed intimidate physician override medical judgment thursday group reiterated opposition calling insulting slap face state medical provider urging fallin veto legislation extremely disappointed today vote sherri baker president medical association said statement thursday simply unconscionable time state face severe physician shortage senate waste time bill patently unconstitutional purpose score political point intimidate physician state measure debated state house representative legislator ultimately voted bill pointed group opposition voiced concern law lead doctor abandoning oklahoma bill co sponsor said think impact taking office 2011 fallin signed dozen bill restricting access reproductive health care center reproductive right nonprofit legal group said thursday new bill blatantly unconstitutional take effect extreme abortion law country roe v wade decision amanda allen senior state legislative counsel center wrote letter fallin thursday allen said group urging fallin veto legislation said larger pattern lawmaker state chipping away abortion right policymakers oklahoma focus advancing policy truly promote woman health safety abortion restriction opposite allen wrote anti choice politician state methodically restricted access abortion neglected advance policy truly address challenge woman family face day allen said bill certainly lead expensive court challenge state oklahoma simply defend light longstanding supreme court precedent fallin week decision bill measure law effect nov 1 forgotten history justice ginsburg criticism roe v wade indiana banned abortion fetus syndrome story published thursday updated friday include liberty counsel comment 
    1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      study woman drive 4 time farther texas law closed abortion clinic texas law closed half state abortion clinic 2013 researcher trying understand burden law place woman trying access abortion important supreme court considering law woman health v hellerstedt court consequential abortion case decade find law place undue burden woman likely struck researcher texas policy evaluation project txpep looking exactly found woman wait week longer appointment woman interviewed able secure abortion logistical financial barrier txpep published significant study american journal public health effect hb2 omnibus anti abortion bill court end partially striking study show burden placed woman result clinic closed law researcher surveyed 398 texas woman comparing woman nearest abortion clinic closed mid 2014 nearest clinic open april 2013 shortly texas legislature debated hb2 result striking woman surveyed 38 percent lived zip code closest clinic open 2013 closed 2014 key finding woman nearest clinic closed travel average 22 mile woman nearest clinic closed traveled average 85 mile time far quarter woman group travel 139 mile abortion case month hb2 went effect abortion provider time adjust initial chaos closure woman nearest clinic closed tougher time measure travel farther pay pocket thing like gas hotel child care likely able access medication abortion instead surgical abortion wanted probably texas law requires different doctor visit medication abortion lot tougher manage live far away unsurprisingly likely report somewhat hard hard care woman nearest clinic closed faced burden instance likely travel 50 mile spend 100 trip percent woman closure group reported facing different kind burden compared 4 percent woman clinic remained open study looked woman eventually got desired abortion account woman able burden high study unusual ability ass multiple burden imposed woman result clinic closure important note burden documented hardship woman experienced result hb2 said study author liza fuentes statement strangely significant difference group woman far pregnancy abortion inconsistent txpep research found hb2 passed small significant increase second trimester abortion procedure safe lot expensive compared trimester procedure explained couple thing researcher wrote long wait time forced hb2 affecting equally difference small study clear researcher said clinic closure hb2 passed resulted significant burden woman able obtain care 
    2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      trump clinton clash dueling dc speech donald trump hillary clinton starting line general election race traded shot capital friday dueling address different c audience warning country backward trump headlined faith freedom coalition road majority summit clinton addressed planned parenthood national conference trump looking solidify standing evangelical christian offered assurance friday restore respect people faith stressed sanctity dignity life doubt wanted throw clinton planned parenthood speech sharp relief took presumptive rival later remark trump warned clinton appoint radical judge eliminate second amendment restrict religious freedom government mandate push federal funding abortion demand moment birth cast support bringing syrian refugee potential clash faith hillary bring hundred thousand refugee hostile belief people different faith value said clinton speech democratic party presumptive nominee said trump presidency country time abortion illegal life woman girl limited clinton thanked nonprofit woman health group abortion provider support democratic primary race january planned parenthood backed clinton offering primary endorsement group 100 year history clinton clear woman issue staple campaign promising abortion right supporter elected president clinton repeated claim trump want america time woman opportunity freedom donald day going let donald trump anybody turn clock told cheering crowd arriving event clinton held private meeting c home massachusetts sen elizabeth warren rumored consideration running mate echoing attack warren recent day clinton attempted elevate importance election middle concerted persistent assault woman health country warned clinton said 2016 election profoundly different previous election campaign trail staple clinton highlighted trump insult woman asserted hard imagine depending defend fundamental right woman trump continued calling clinton crooked hillary referred ongoing email scandal took task domestic foreign policy stance trump interrupted protester annual gathering evangelical christian protester shouted stop hate stop trump refugee welcome trump called chant little freedom speech added little rude 
    3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         grand jury texas indicts activist planned parenthood video houston grand jury investigating criminal allegation planned parenthood stemming series undercover video monday instead indicted anti abortion activist shot footage stunning turn event grand jury declined indict official abortion provider instead handed felony charge tampering government record center medical progress founder david daleiden center employee sandra merritt daleidon charged misdemeanor count related purchasing human organ called investigate allegation criminal conduct planned parenthood gulf coast harris county district attorney devon anderson said stated outset investigation evidence lead evidence uncovered course investigation presented grand jury respect decision difficult case case sprang series dramatic undercover video center medical progress employee posed prospective buyer fetal tissue captured employee planned parenthood contractor appearing discus practice banned law video released online year planned parenthood claimed selective editing created misperception anderson provide detail charge including record record allegedly tampered daleiden face charge related buying human organ anderson office said provide detail document charging daleiden merritt formally public center medical progress us undercover technique investigative journalist decade exercising amendment right freedom speech press follows applicable law daleiden said statement response indictment respect process harris county district attorney note buying fetal tissue requires seller planned parenthood deny admission leadership fetal organ sale captured video world statement continued anti abortion extremist spent year creating fake company creating fake identity lying breaking law find improper illegal activity eric ferrero vice president communication planned parenthood federation america said statement dust settle truth come totally clear people engaged wrongdoing criminal fraud glad held accountable ferrero said video shot texas riled anti abortion activist prompted republican congress summer unsuccessfully called cutting funding organization texas gov greg abbott republican called footage planned parenthood clinic houston repulsive unconscionable showed people pretending company procures fetal tissue research touring facility texas attorney general ken paxton opened investigation video abbott said indictment impact state investigation state texas continue protect life continue support legislation prohibiting sale transfer fetal tissue said statement rep diane black r tenn author house passed defund planned parenthood act 2015 said profoundly disappointed indictment sad day america harvest body part aborted baby escape consequence action courageous truth teller expose misdeed handed politically motivated indictment instead said planned parenthood say abides law allows provider reimbursed cost processing tissue donated woman abortion texas video fifth released group release melaney linton president houston planned parenthood clinic told state lawmaker summer likely feature actor pretending company called biomax asking leading question select potential donor supposed study sickle cell anemia linton said footage feature interaction initiated biomax doctor adjust abortion patient offered donate tissue medical research said planned parenthood believed video manipulated earlier month planned parenthood sued center california federal court alleging extensive criminal misconduct lawsuit say center video result numerous illegality including making recording consent registering false identity state agency violating non disclosure agreement lawsuit filed daleiden told associated press looked forward confronting planned parenthood court associated press contributed report 
    4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       reproductive right hang balance debate moderator drop ball washington year supreme court established right safe legal abortion roe v wade stake higher side abortion debate state enacted 288 new abortion restriction past year shut slew clinic country president nominate supreme court justice determine fate legal abortion decade come abortion access million woman hang balance issue neglected presidential debate moderator causing issue reproductive right fade 2016 race democratic candidate asked reproductive right debate republican asked abortion funding planned parenthood debate participated far advocate working abortion right baffled silence real important difference candidate loss american woman explored said jess mcintosh spokeswoman emily list group help elect pro choice woman office nbc moderator ask sen bernie sander vt new health plan released hour democratic debate network hosted sunday handle public funding abortion press hillary clinton view federal restriction medicaid funding abortion repealed sen marco rubio r fla ted cruz r texas asked past gop debate opposition allowing victim rape incest abortion position significantly conservative held prior republican presidential nominee abortion related question gop frontrunner donald trump fielded debate august fox megyn kelly asked 1999 comment pro choice stance abortion murkier day moderator chosen ask american united life anti abortion group want candidate side explain support public funding abortion kind clinic regulation conservative state passed difficult abortion provider stay open pro life american love know candidate support health safety standard woman exposed great risk abortion clinic said kristi hamrick spokeswoman aul 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ...                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    4589                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                russia call war party bluff license dmca cold war 2 0 reached unprecedented hysterical level hot war break november 8 presidential election clinton cash machine supported neocon neoliberalcon think tank medium complex british establishment corporate medium mouthpiece anglo american self appointed leader free world racking demonization russia putinism pure incandescence hot war break november 8 presidential election layer fear loathing fact veil bluff let start russian naval task force syria led officially designated heavy aircraft carrying cruiser admiral kuznetsov stationed eastern mediterranean february 2017 supporting operation strand salafi jihadism admiral kuznetsov fully equipped anti ship air defense artillery anti submarine warfare system defend vast array threat unlike nato vessel advertisement predictably nato spinning alarm northern fleet baltic fleet way mediterranean wrong northern fleet baltic fleet ship going heart matter capability russian naval task force matched 300 400 missile system deployed syria russia de facto rivaling firepower sixth fleet comprehensive military analysis make clear russia basically fly zone syria fly zone viscerally promoted hillary clinton impossible achieve perspective impotence transmuted outright anger exhibited pentagon neocon neoliberalcon vassal add outright war pentagon cia syrian war theater pentagon back ypg kurd necessarily favor regime change damascus cia back weaponizing moderate al qaeda linked infiltrated rebel compounding trademark obama administration stooge school foreign policy american threat flown liberally negan skull crushing bloody baton new season walking dead pentagon head ash carter certified neocon threatened consequence potential strike syrian arab army saa force punish regime pentagon broke kerry lavrov ceasefire advertisement president obama took time weighing option end backed virtually elected establishment hillary clinton fateful decision able fly zone russia decides punish regime moscow telegraphed russia defense ministry spokesman major general igor konashenkov definitely consequence imposing shadow hot war sun tzu strike washington course reserve strike nuclear capability fully support donald trump demonized allow current hysteria literally nuclear consider matter 500 anti missile system effectively seal russia air space moscow admit record unleash relentless arm race intel source close connection master universe time opposed cold war 2 0 counter productive add necessary nuance united state lost arm race indulging trillion dollar worthless endless war afghanistan iraq syria libya longer global power defend obsolete missile thaad patriot aegis land based ballistic defense system russian icbm russian sealed airspace russian generation ahead deep recess shadow war planning pentagon know russian defense ministry know event dr strangelove launched nuclear preemptive strike russia russian population protected defensive missile system nuclear bomb shelter major city warning russian television idle population know terrifying event nuclear war breaking 
    4590                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  bernie sander democratic primary gave leverage intend use pressure hillary clinton print sen bernie sander laid way leverage popularity emerged democratic primary continue push hillary clinton left win presidency month interview published monday washington post sander argued democratic party progressive presidential nominee emphasized saw role demand democratic party implement party platform ally helped shape vigorously opposition clinton attempted abandon platform progressive element leverage think senate taking entire democratic party establishment know taking powerful political organization clinton people sander said referenced number state primary 22 give lot leverage leverage intend use added vermont senator emphasized cowed knowledge proposal received likely republican controlled house representative 
    4591                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          pipeline police strip search native girl leave naked jail overnight pressure start construction dakota access pipeline increase violence peaceful protester noticed arm indigenous people 
    4592    currency crisis alasdair macleod vexed question dollar tweet home gold gold news currency crisis alasdair macleod vexed question dollar little doubt rapid expansion dollar denominated debt monetary quantity financial crisis lead currency crisis know dollar alasdair macleod major paper currency massively inflated recent year dollar acting world reserve currency dollar go fiat monies cataclysmic event watch currency behave increasingly unexpected seemingly irrational way fundamental japan good yen remains strongest currency big eurozone risk systemic collapse overwhelmed political financial headwind euro exchange rate proved relatively impervious deep uncertainty british economy strongest sterling weakest major today foreign exchange evidence subjectivity triumph macroeconomic thinking mackay extraordinary popular delusion madness crowd beat computer modelling time furthermore official attempt establish rate dollar address separate question value dollar relative currency purchasing power good service chart indicates dollar behaved currency year trade weighted predefined currency basis dxy noted dollar risen measure roughly 18 early 2014 time chinese yuan fallen dollar 12 actually risen slightly dxy basket particularly euro component gained 12 early 2014 matter far devaluing routinely told dollar centric analyst yuan relatively stable time basket currency weak dollar yen strong euro sterling look fed federal open market committee point view america run record trade deficit china major economy china term trade improved excepting japan fed bound sensitive dollar exchange rate china yuan furthermore occasion fed signalled going raise fed fund rate backed chinese lowered rate pegged yuan dollar chinese devaluation dollar obviously prime concern fed situation better understood people bank position taken account bank selling treasury stock large quantity stockpiling commodity oil proceeds diversifying japanese government bond china dollar welcomed market short quality collateral raw currency china supply failed stop dollar rising yuan furthermore china asian middle eastern state selling american paper demand international player buy immense determine underlying direction dollar exchange rate situation exploited people bank effect people bank position dictate fed policy adjusting rate prepared supply dollar market long dollar remains fundamentally strong slow pace treasury dollar sale dollar rise fed planned interest rate rise deferred understood properly western commentator erroneously think china forced defend declining yuan truth interesting happens ahead december fomc meeting umpteenth time promised rise fed fund rate major consideration china foreign exchange policy outlook euro eurozone represents market large added importance tagged asian continent little doubt china see long term future aligned europe america despite europe current trouble like situation primarily strategic importance europe economy need rescuing stage future opportunity china intervention plan long term increasingly valid deeper hole eurozone dig disintegration eu beneficial chinese ambition short term euro broken crucial trend line dollar completed continuation head shoulder pattern targeting 1 0600 area previous low seen march november 2015 second chart people bank fed need chart expert happening brexit bad news euro racing certainty event turn start new round political economic trouble eurozone italian economy particular imploding non performing loan problem roughly 40 private sector gdp china moment steer course yuan euro devaluation dollar rise fed see euro weakness increase currency induced deflation economy loss competitiveness export chinese exporter obvious beneficiary blame deflation china foreign exchange machination china probably care long term consequence action economy china selling treasury reducing dollar exposure add stockpile raw material oil want indebted business trading maintaining favourable exchange rate dollar particularly given developing train wreck eurozone lot fed gold commodity principal driver gold price prospect monetary inflation transmuting price inflation inability central bank respond threat raising interest rate sufficiently control balance consumer preference good holding money course measuring gold dollar reserve currency stated exchange consideration dollar currency second dollar basket commodity note long term price commodity measured gold considerably stable price commodity measured fiat currency china behaved thoroughly aware gold pricing attribute deliberate policy dominating market bullion different domination gold paper market china invested unprofitable gold mine largest producer 450 tonne annually state monopolises china refining capacity import dor refining country doubt 1983 accumulated substantial quantity bullion included monetary reserve furthermore country encouraged population television medium accumulate physical gold mistake thirty year chinese government credible attempt gain ultimate control physical gold market extend gold protection citizen china manipulate gold price instead described earlier manipulating dollar regulating exchange rate discouraging fed raising interest rate temporary balancing act continues long desperate bank indebted borrower continue scramble dollar china know fed moment appears powerless manage economic outcome firmly trapped china currency management interest rate stuck lower bound worse weak euro dollar index dxy heavily weighted 57 threatens force dxy index higher result inevitably monetary policy address future price inflation virtually guarantee higher gold price 2017 despite american wishful thinking gold remains centre financial system central partly china ensures china ultimate money commodity trade purpose china likely gold fully compensate reserve loss destruction dollar fiat currency reserve book deliberately selling dollar exposure lest forget communist economist china taught capitalism destroys clearer proof performance economy dollar intend caught demise understand understand monetary role gold future determined china china market decision moment regarded ultimate insurance global currency failure 
    4593                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          paper tiger isi dig mosul written eric margolis soldier war correspondent covered 14 conflict look medium hoopla tightening siege mosul iraq shake head western organized liberation mosul bigger piece political military theater seen islamic state defender mosul paper tiger blown proportion western medium writer saying year armed mob 20 malcontent religious fanatic modern day anarchist cadre iraqi army officer military experience officer saddam hussain bent revenge destruction nation lynching late leader rank file military training little discipline degraded communication ragged logistics fact today islamic state ottoman empire term bashi bazouks collection irregular cut throat scum gutter sent punish terrorize enemy mean torture rapine looting arson amazed faux western war isi leisurely nature lack lan hesitancy view isi created ally weapon syria government afghan mujahadin saudi overthrow soviet backed afghan government israel tried tactic helping create hamas palestine hezbollah lebanon cultivated split plo isi ad hoc movement want punish west saudi gross carnage inflicted arab world western kurdish auxiliary force sitting 1 5 hour drive mosul town raqqa year instead western mainly warplane gingerly bombing target effort convince breakaway isi rejoin led force fight damascus regime note isi appear attacked israel playing important role destruction syria report israel providing logistic medical support siege mosul played western medium heroic second stalingrad fooled 3 5 000 lightly armed fighter mosul raqqa maybe leader likely long gone heavy weapon air cover poor communication rag tag fighter run ammunition explosive quickly encircling mosul 50 000 western led soldier backed heavy artillery rocket battery tank armored vehicle awesome air power western imperial force composed tough kurdish peshmerga fighter iraqi army special force syrian kurd iranian volunteer irregular force 5 000 combat troop called advisor plus small number french canadian british special force hovering background thousand turkish troop supported armor artillery ready liberate iraq ottoman empire current military operation syria iraq realization imperialist fondest dream native troop led white officer model old british indian raj washington arm trained equips financed native auxiliary caught dangerous dilemma political movement delighted control iraq second largest city guerilla force holed urban area highly vulnerable concentrated air attack surrounded happening right flat fertile crescent tree ground force totally vulnerable air power recent 1967 1973 israel arab war 2003 iraq war shown dispersion guerilla tactic hope lack air cover force best advise disperse region continue hit run attack risk destroyed bloody minded young fanatic heed military logic precedent favor making stand ruin mosul raqqa happens western leader compete claim authorship faux crusade paper tiger isi lewrockwell com related 
    Name: text, Length: 4594, dtype: object



# Pre-Processing 2


```python
from transformers import AutoTokenizer
```


```python
wpt = nltk.WordPunctTokenizer() 
stop_words = nltk.corpus.stopwords.words('english') # initialize the stop word list

def normalize_document(doc):
    # lower case and remove special characters\whitespaces
    doc = re.sub(r'[^a-zA-Z\s]', '', doc, re.I|re.A) # re.I ignores cases, re.A matches only ASCII characters)
    doc = doc.lower()
    doc = doc.strip()
    # tokenize document
    tokens = wpt.tokenize(doc)
    # filter stopwords out of document
    filtered_tokens = [token for token in tokens if token not in stop_words]
    # re-create document from filtered tokens
    doc = ' '.join(filtered_tokens)
    return doc

normalize_corpus = np.vectorize(normalize_document)
```


```python
reviews = data["text"]
norm_reviews = pd.DataFrame({"norm_text": normalize_corpus(data["text"])})

print(reviews.head())
print(reviews.name)  # Accessing the name of the Series
```

    0    target roe v wade oklahoma bill making felony perform abortion wait governor decision update gov fallin vetoed bill friday head lawmaker oklahoma approved bill thursday performing abortion felony revoke medical license physician assist procedure sweeping measure opponent described unconstitutional unprecedented head gov mary fallin r day including sunday decide sign bill veto allow law signature according spokesman governor withhold comment bill bill staff chance review michael mcnutt spokesman fallin said email oklahoma bill measure kind according center reproductive right say state seeking ban abortion simply banned procedure attaching penalty like according measure known sb1552 person performs induces abortion guilty felony punished year state penitentiary legislation say physician participates abortion deemed unprofessional conduct bill prohibited obtaining renewing license practice medicine state medical license stripped doctor perform abortion deemed necessary save mother life yes hospital perform abortion c doctor say hospital let talk bill passed oklahoma house representative vote 59 9 month thursday state senate passed vote 33 12 believe life begin conception protected believe core function state government defend life beginning conception state sen nathan dahm republican represents tulsa county told associated press dahm said hope oklahoma measure eventually lead overturning roe v wade 1973 supreme court decision recognized woman right abortion dahm respond message seeking comment thursday friday dawn laguens executive vice president planned parenthood federation america said month oklahoma bill ban abortion plain simple legislation sent fallin thursday reckless dangerous according ilyse hogue president naral pro choice america bill put doctor cross hair providing woman option exercising fundamental right decide start family hogue said statement creates penalty doctor job performing safe legal medical procedure liberty counsel group rose national prominence year defending kentucky clerk refused sign sex marriage license said friday helped support legislation oklahoma organization vowed defend court particular bill put target roe v wade mat staver group founder chairman said interview friday oklahoma line sand sanctity human life standing protecting innocent child staver said group met oklahoma lawmaker legislation filed offering legal analysis discussion begun state proposing measure oklahoma bill kind staver said said possible state follow oklahoma lead bolt step right direction view staver said challenged prepared defend oklahoma state taking big step limit abortion oklahoma state medical association called measure troubling said position legality abortion long practice remains legal group said opposed legislation designed intimidate physician override medical judgment thursday group reiterated opposition calling insulting slap face state medical provider urging fallin veto legislation extremely disappointed today vote sherri baker president medical association said statement thursday simply unconscionable time state face severe physician shortage senate waste time bill patently unconstitutional purpose score political point intimidate physician state measure debated state house representative legislator ultimately voted bill pointed group opposition voiced concern law lead doctor abandoning oklahoma bill co sponsor said think impact taking office 2011 fallin signed dozen bill restricting access reproductive health care center reproductive right nonprofit legal group said thursday new bill blatantly unconstitutional take effect extreme abortion law country roe v wade decision amanda allen senior state legislative counsel center wrote letter fallin thursday allen said group urging fallin veto legislation said larger pattern lawmaker state chipping away abortion right policymakers oklahoma focus advancing policy truly promote woman health safety abortion restriction opposite allen wrote anti choice politician state methodically restricted access abortion neglected advance policy truly address challenge woman family face day allen said bill certainly lead expensive court challenge state oklahoma simply defend light longstanding supreme court precedent fallin week decision bill measure law effect nov 1 forgotten history justice ginsburg criticism roe v wade indiana banned abortion fetus syndrome story published thursday updated friday include liberty counsel comment 
    1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            study woman drive 4 time farther texas law closed abortion clinic texas law closed half state abortion clinic 2013 researcher trying understand burden law place woman trying access abortion important supreme court considering law woman health v hellerstedt court consequential abortion case decade find law place undue burden woman likely struck researcher texas policy evaluation project txpep looking exactly found woman wait week longer appointment woman interviewed able secure abortion logistical financial barrier txpep published significant study american journal public health effect hb2 omnibus anti abortion bill court end partially striking study show burden placed woman result clinic closed law researcher surveyed 398 texas woman comparing woman nearest abortion clinic closed mid 2014 nearest clinic open april 2013 shortly texas legislature debated hb2 result striking woman surveyed 38 percent lived zip code closest clinic open 2013 closed 2014 key finding woman nearest clinic closed travel average 22 mile woman nearest clinic closed traveled average 85 mile time far quarter woman group travel 139 mile abortion case month hb2 went effect abortion provider time adjust initial chaos closure woman nearest clinic closed tougher time measure travel farther pay pocket thing like gas hotel child care likely able access medication abortion instead surgical abortion wanted probably texas law requires different doctor visit medication abortion lot tougher manage live far away unsurprisingly likely report somewhat hard hard care woman nearest clinic closed faced burden instance likely travel 50 mile spend 100 trip percent woman closure group reported facing different kind burden compared 4 percent woman clinic remained open study looked woman eventually got desired abortion account woman able burden high study unusual ability ass multiple burden imposed woman result clinic closure important note burden documented hardship woman experienced result hb2 said study author liza fuentes statement strangely significant difference group woman far pregnancy abortion inconsistent txpep research found hb2 passed small significant increase second trimester abortion procedure safe lot expensive compared trimester procedure explained couple thing researcher wrote long wait time forced hb2 affecting equally difference small study clear researcher said clinic closure hb2 passed resulted significant burden woman able obtain care 
    2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            trump clinton clash dueling dc speech donald trump hillary clinton starting line general election race traded shot capital friday dueling address different c audience warning country backward trump headlined faith freedom coalition road majority summit clinton addressed planned parenthood national conference trump looking solidify standing evangelical christian offered assurance friday restore respect people faith stressed sanctity dignity life doubt wanted throw clinton planned parenthood speech sharp relief took presumptive rival later remark trump warned clinton appoint radical judge eliminate second amendment restrict religious freedom government mandate push federal funding abortion demand moment birth cast support bringing syrian refugee potential clash faith hillary bring hundred thousand refugee hostile belief people different faith value said clinton speech democratic party presumptive nominee said trump presidency country time abortion illegal life woman girl limited clinton thanked nonprofit woman health group abortion provider support democratic primary race january planned parenthood backed clinton offering primary endorsement group 100 year history clinton clear woman issue staple campaign promising abortion right supporter elected president clinton repeated claim trump want america time woman opportunity freedom donald day going let donald trump anybody turn clock told cheering crowd arriving event clinton held private meeting c home massachusetts sen elizabeth warren rumored consideration running mate echoing attack warren recent day clinton attempted elevate importance election middle concerted persistent assault woman health country warned clinton said 2016 election profoundly different previous election campaign trail staple clinton highlighted trump insult woman asserted hard imagine depending defend fundamental right woman trump continued calling clinton crooked hillary referred ongoing email scandal took task domestic foreign policy stance trump interrupted protester annual gathering evangelical christian protester shouted stop hate stop trump refugee welcome trump called chant little freedom speech added little rude 
    3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               grand jury texas indicts activist planned parenthood video houston grand jury investigating criminal allegation planned parenthood stemming series undercover video monday instead indicted anti abortion activist shot footage stunning turn event grand jury declined indict official abortion provider instead handed felony charge tampering government record center medical progress founder david daleiden center employee sandra merritt daleidon charged misdemeanor count related purchasing human organ called investigate allegation criminal conduct planned parenthood gulf coast harris county district attorney devon anderson said stated outset investigation evidence lead evidence uncovered course investigation presented grand jury respect decision difficult case case sprang series dramatic undercover video center medical progress employee posed prospective buyer fetal tissue captured employee planned parenthood contractor appearing discus practice banned law video released online year planned parenthood claimed selective editing created misperception anderson provide detail charge including record record allegedly tampered daleiden face charge related buying human organ anderson office said provide detail document charging daleiden merritt formally public center medical progress us undercover technique investigative journalist decade exercising amendment right freedom speech press follows applicable law daleiden said statement response indictment respect process harris county district attorney note buying fetal tissue requires seller planned parenthood deny admission leadership fetal organ sale captured video world statement continued anti abortion extremist spent year creating fake company creating fake identity lying breaking law find improper illegal activity eric ferrero vice president communication planned parenthood federation america said statement dust settle truth come totally clear people engaged wrongdoing criminal fraud glad held accountable ferrero said video shot texas riled anti abortion activist prompted republican congress summer unsuccessfully called cutting funding organization texas gov greg abbott republican called footage planned parenthood clinic houston repulsive unconscionable showed people pretending company procures fetal tissue research touring facility texas attorney general ken paxton opened investigation video abbott said indictment impact state investigation state texas continue protect life continue support legislation prohibiting sale transfer fetal tissue said statement rep diane black r tenn author house passed defund planned parenthood act 2015 said profoundly disappointed indictment sad day america harvest body part aborted baby escape consequence action courageous truth teller expose misdeed handed politically motivated indictment instead said planned parenthood say abides law allows provider reimbursed cost processing tissue donated woman abortion texas video fifth released group release melaney linton president houston planned parenthood clinic told state lawmaker summer likely feature actor pretending company called biomax asking leading question select potential donor supposed study sickle cell anemia linton said footage feature interaction initiated biomax doctor adjust abortion patient offered donate tissue medical research said planned parenthood believed video manipulated earlier month planned parenthood sued center california federal court alleging extensive criminal misconduct lawsuit say center video result numerous illegality including making recording consent registering false identity state agency violating non disclosure agreement lawsuit filed daleiden told associated press looked forward confronting planned parenthood court associated press contributed report 
    4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             reproductive right hang balance debate moderator drop ball washington year supreme court established right safe legal abortion roe v wade stake higher side abortion debate state enacted 288 new abortion restriction past year shut slew clinic country president nominate supreme court justice determine fate legal abortion decade come abortion access million woman hang balance issue neglected presidential debate moderator causing issue reproductive right fade 2016 race democratic candidate asked reproductive right debate republican asked abortion funding planned parenthood debate participated far advocate working abortion right baffled silence real important difference candidate loss american woman explored said jess mcintosh spokeswoman emily list group help elect pro choice woman office nbc moderator ask sen bernie sander vt new health plan released hour democratic debate network hosted sunday handle public funding abortion press hillary clinton view federal restriction medicaid funding abortion repealed sen marco rubio r fla ted cruz r texas asked past gop debate opposition allowing victim rape incest abortion position significantly conservative held prior republican presidential nominee abortion related question gop frontrunner donald trump fielded debate august fox megyn kelly asked 1999 comment pro choice stance abortion murkier day moderator chosen ask american united life anti abortion group want candidate side explain support public funding abortion kind clinic regulation conservative state passed difficult abortion provider stay open pro life american love know candidate support health safety standard woman exposed great risk abortion clinic said kristi hamrick spokeswoman aul 
    Name: text, dtype: object
    text
    


```python
print(norm_reviews.columns)
```

    Index(['norm_text'], dtype='object')
    


```python
import nltk
nltk.download('punkt')
```

    [nltk_data] Downloading package punkt to
    [nltk_data]     C:\Users\Source\AppData\Roaming\nltk_data...
    [nltk_data]   Package punkt is already up-to-date!
    




    True




```python
# Preprocessing function
def preprocess_text(text):
    # Remove special characters and digits
    text = re.sub(r'[^a-zA-Z\s]', '', text)
    # Convert text to lowercase
    text = text.lower()
    # Tokenization
    tokens = word_tokenize(text)
    # Remove stopwords
    stop_words = set(stopwords.words('english'))
    filtered_tokens = [word for word in tokens if word not in stop_words]
    # Lemmatization
    lemmatizer = WordNetLemmatizer()
    lemmatized_tokens = [lemmatizer.lemmatize(word) for word in filtered_tokens]
    # Join tokens back into string
    preprocessed_text = ' '.join(lemmatized_tokens)
    return preprocessed_text
```


```python
# Apply preprocessing to the text column
data['preprocessed_text'] = data['text'].apply(preprocess_text)
```


```python
data.head(2)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>text</th>
      <th>label</th>
      <th>preprocessed_text</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>target roe v wade oklahoma bill making felony perform abortion wait governor decision update gov fallin vetoed bill friday head lawmaker oklahoma approved bill thursday performing abortion felony revoke medical license physician assist procedure sweeping measure opponent described unconstitutional unprecedented head gov mary fallin r day including sunday decide sign bill veto allow law signature according spokesman governor withhold comment bill bill staff chance review michael mcnutt spokesman fallin said email oklahoma bill measure kind according center reproductive right say state seeking ban abortion simply banned procedure attaching penalty like according measure known sb1552 person performs induces abortion guilty felony punished year state penitentiary legislation say physician participates abortion deemed unprofessional conduct bill prohibited obtaining renewing license practice medicine state medical license stripped doctor perform abortion deemed necessary save mother life yes hospital perform abortion c doctor say hospital let talk bill passed oklahoma house representative vote 59 9 month thursday state senate passed vote 33 12 believe life begin conception protected believe core function state government defend life beginning conception state sen nathan dahm republican represents tulsa county told associated press dahm said hope oklahoma measure eventually lead overturning roe v wade 1973 supreme court decision recognized woman right abortion dahm respond message seeking comment thursday friday dawn laguens executive vice president planned parenthood federation america said month oklahoma bill ban abortion plain simple legislation sent fallin thursday reckless dangerous according ilyse hogue president naral pro choice america bill put doctor cross hair providing woman option exercising fundamental right decide start family hogue said statement creates penalty doctor job performing safe legal medical procedure liberty counsel group rose national prominence year defending kentucky clerk refused sign sex marriage license said friday helped support legislation oklahoma organization vowed defend court particular bill put target roe v wade mat staver group founder chairman said interview friday oklahoma line sand sanctity human life standing protecting innocent child staver said group met oklahoma lawmaker legislation filed offering legal analysis discussion begun state proposing measure oklahoma bill kind staver said said possible state follow oklahoma lead bolt step right direction view staver said challenged prepared defend oklahoma state taking big step limit abortion oklahoma state medical association called measure troubling said position legality abortion long practice remains legal group said opposed legislation designed intimidate physician override medical judgment thursday group reiterated opposition calling insulting slap face state medical provider urging fallin veto legislation extremely disappointed today vote sherri baker president medical association said statement thursday simply unconscionable time state face severe physician shortage senate waste time bill patently unconstitutional purpose score political point intimidate physician state measure debated state house representative legislator ultimately voted bill pointed group opposition voiced concern law lead doctor abandoning oklahoma bill co sponsor said think impact taking office 2011 fallin signed dozen bill restricting access reproductive health care center reproductive right nonprofit legal group said thursday new bill blatantly unconstitutional take effect extreme abortion law country roe v wade decision amanda allen senior state legislative counsel center wrote letter fallin thursday allen said group urging fallin veto legislation said larger pattern lawmaker state chipping away abortion right policymakers oklahoma focus advancing policy truly promote woman health safety abortion restriction opposite allen wrote anti choice politician state methodically restricted access abortion neglected advance policy truly address challenge woman family face day allen said bill certainly lead expensive court challenge state oklahoma simply defend light longstanding supreme court precedent fallin week decision bill measure law effect nov 1 forgotten history justice ginsburg criticism roe v wade indiana banned abortion fetus syndrome story published thursday updated friday include liberty counsel comment</td>
      <td>REAL</td>
      <td>target roe v wade oklahoma bill making felony perform abortion wait governor decision update gov fallin vetoed bill friday head lawmaker oklahoma approved bill thursday performing abortion felony revoke medical license physician assist procedure sweeping measure opponent described unconstitutional unprecedented head gov mary fallin r day including sunday decide sign bill veto allow law signature according spokesman governor withhold comment bill bill staff chance review michael mcnutt spokesman fallin said email oklahoma bill measure kind according center reproductive right say state seeking ban abortion simply banned procedure attaching penalty like according measure known sb person performs induces abortion guilty felony punished year state penitentiary legislation say physician participates abortion deemed unprofessional conduct bill prohibited obtaining renewing license practice medicine state medical license stripped doctor perform abortion deemed necessary save mother life yes hospital perform abortion c doctor say hospital let talk bill passed oklahoma house representative vote month thursday state senate passed vote believe life begin conception protected believe core function state government defend life beginning conception state sen nathan dahm republican represents tulsa county told associated press dahm said hope oklahoma measure eventually lead overturning roe v wade supreme court decision recognized woman right abortion dahm respond message seeking comment thursday friday dawn laguens executive vice president planned parenthood federation america said month oklahoma bill ban abortion plain simple legislation sent fallin thursday reckless dangerous according ilyse hogue president naral pro choice america bill put doctor cross hair providing woman option exercising fundamental right decide start family hogue said statement creates penalty doctor job performing safe legal medical procedure liberty counsel group rose national prominence year defending kentucky clerk refused sign sex marriage license said friday helped support legislation oklahoma organization vowed defend court particular bill put target roe v wade mat staver group founder chairman said interview friday oklahoma line sand sanctity human life standing protecting innocent child staver said group met oklahoma lawmaker legislation filed offering legal analysis discussion begun state proposing measure oklahoma bill kind staver said said possible state follow oklahoma lead bolt step right direction view staver said challenged prepared defend oklahoma state taking big step limit abortion oklahoma state medical association called measure troubling said position legality abortion long practice remains legal group said opposed legislation designed intimidate physician override medical judgment thursday group reiterated opposition calling insulting slap face state medical provider urging fallin veto legislation extremely disappointed today vote sherri baker president medical association said statement thursday simply unconscionable time state face severe physician shortage senate waste time bill patently unconstitutional purpose score political point intimidate physician state measure debated state house representative legislator ultimately voted bill pointed group opposition voiced concern law lead doctor abandoning oklahoma bill co sponsor said think impact taking office fallin signed dozen bill restricting access reproductive health care center reproductive right nonprofit legal group said thursday new bill blatantly unconstitutional take effect extreme abortion law country roe v wade decision amanda allen senior state legislative counsel center wrote letter fallin thursday allen said group urging fallin veto legislation said larger pattern lawmaker state chipping away abortion right policymakers oklahoma focus advancing policy truly promote woman health safety abortion restriction opposite allen wrote anti choice politician state methodically restricted access abortion neglected advance policy truly address challenge woman family face day allen said bill certainly lead expensive court challenge state oklahoma simply defend light longstanding supreme court precedent fallin week decision bill measure law effect nov forgotten history justice ginsburg criticism roe v wade indiana banned abortion fetus syndrome story published thursday updated friday include liberty counsel comment</td>
    </tr>
    <tr>
      <th>1</th>
      <td>study woman drive 4 time farther texas law closed abortion clinic texas law closed half state abortion clinic 2013 researcher trying understand burden law place woman trying access abortion important supreme court considering law woman health v hellerstedt court consequential abortion case decade find law place undue burden woman likely struck researcher texas policy evaluation project txpep looking exactly found woman wait week longer appointment woman interviewed able secure abortion logistical financial barrier txpep published significant study american journal public health effect hb2 omnibus anti abortion bill court end partially striking study show burden placed woman result clinic closed law researcher surveyed 398 texas woman comparing woman nearest abortion clinic closed mid 2014 nearest clinic open april 2013 shortly texas legislature debated hb2 result striking woman surveyed 38 percent lived zip code closest clinic open 2013 closed 2014 key finding woman nearest clinic closed travel average 22 mile woman nearest clinic closed traveled average 85 mile time far quarter woman group travel 139 mile abortion case month hb2 went effect abortion provider time adjust initial chaos closure woman nearest clinic closed tougher time measure travel farther pay pocket thing like gas hotel child care likely able access medication abortion instead surgical abortion wanted probably texas law requires different doctor visit medication abortion lot tougher manage live far away unsurprisingly likely report somewhat hard hard care woman nearest clinic closed faced burden instance likely travel 50 mile spend 100 trip percent woman closure group reported facing different kind burden compared 4 percent woman clinic remained open study looked woman eventually got desired abortion account woman able burden high study unusual ability ass multiple burden imposed woman result clinic closure important note burden documented hardship woman experienced result hb2 said study author liza fuentes statement strangely significant difference group woman far pregnancy abortion inconsistent txpep research found hb2 passed small significant increase second trimester abortion procedure safe lot expensive compared trimester procedure explained couple thing researcher wrote long wait time forced hb2 affecting equally difference small study clear researcher said clinic closure hb2 passed resulted significant burden woman able obtain care</td>
      <td>REAL</td>
      <td>study woman drive time farther texas law closed abortion clinic texas law closed half state abortion clinic researcher trying understand burden law place woman trying access abortion important supreme court considering law woman health v hellerstedt court consequential abortion case decade find law place undue burden woman likely struck researcher texas policy evaluation project txpep looking exactly found woman wait week longer appointment woman interviewed able secure abortion logistical financial barrier txpep published significant study american journal public health effect hb omnibus anti abortion bill court end partially striking study show burden placed woman result clinic closed law researcher surveyed texas woman comparing woman nearest abortion clinic closed mid nearest clinic open april shortly texas legislature debated hb result striking woman surveyed percent lived zip code closest clinic open closed key finding woman nearest clinic closed travel average mile woman nearest clinic closed traveled average mile time far quarter woman group travel mile abortion case month hb went effect abortion provider time adjust initial chaos closure woman nearest clinic closed tougher time measure travel farther pay pocket thing like gas hotel child care likely able access medication abortion instead surgical abortion wanted probably texas law requires different doctor visit medication abortion lot tougher manage live far away unsurprisingly likely report somewhat hard hard care woman nearest clinic closed faced burden instance likely travel mile spend trip percent woman closure group reported facing different kind burden compared percent woman clinic remained open study looked woman eventually got desired abortion account woman able burden high study unusual ability as multiple burden imposed woman result clinic closure important note burden documented hardship woman experienced result hb said study author liza fuentes statement strangely significant difference group woman far pregnancy abortion inconsistent txpep research found hb passed small significant increase second trimester abortion procedure safe lot expensive compared trimester procedure explained couple thing researcher wrote long wait time forced hb affecting equally difference small study clear researcher said clinic closure hb passed resulted significant burden woman able obtain care</td>
    </tr>
  </tbody>
</table>
</div>



#  Split


```python
from sklearn.model_selection import train_test_split
```


```python
X = data['preprocessed_text']
y = data['label']
```


```python
X_train, X_test, y_train, y_test = train_test_split(X,y, test_size=0.2, random_state=69)
```

# TfidfVectorizer


```python
from sklearn.feature_extraction.text import TfidfVectorizer

# Initialize TF-IDF vectorizer
tfidf_vectorizer = TfidfVectorizer()

# Transform training data into TF-IDF matrix
X_train_tfidf = tfidf_vectorizer.fit_transform(X_train)

# Transform testing data into TF-IDF matrix (use transform, not fit_transform)
X_test_tfidf = tfidf_vectorizer.transform(X_test)
```


```python
# Convert TF-IDF matrix to an array
tfidf_array = X_train_tfidf.toarray()

# Get feature names from TF-IDF vectorizer
feature_names = tfidf_vectorizer.get_feature_names_out()

# Create DataFrame from TF-IDF array
tfidf_df = pd.DataFrame(tfidf_array, columns=feature_names)

# Display the DataFrame
tfidf_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>aa</th>
      <th>aaa</th>
      <th>aab</th>
      <th>aabenraa</th>
      <th>aac</th>
      <th>aadhar</th>
      <th>aahing</th>
      <th>aaj</th>
      <th>aakar</th>
      <th>aakhri</th>
      <th>aaliya</th>
      <th>aand</th>
      <th>aap</th>
      <th>aapke</th>
      <th>aapko</th>
      <th>aapne</th>
      <th>aaps</th>
      <th>aapse</th>
      <th>aaron</th>
      <th>aarp</th>
      <th>aaso</th>
      <th>aata</th>
      <th>aau</th>
      <th>aauw</th>
      <th>aaye</th>
      <th>aayush</th>
      <th>ab</th>
      <th>aba</th>
      <th>abaaoud</th>
      <th>ababa</th>
      <th>aback</th>
      <th>abad</th>
      <th>abadi</th>
      <th>abaldo</th>
      <th>aban</th>
      <th>abandon</th>
      <th>abandoned</th>
      <th>abandoning</th>
      <th>abandonment</th>
      <th>abandonnig</th>
      <th>abated</th>
      <th>abatement</th>
      <th>abating</th>
      <th>abattoir</th>
      <th>abay</th>
      <th>abba</th>
      <th>abbar</th>
      <th>abbas</th>
      <th>abbey</th>
      <th>abbott</th>
      <th>...</th>
      <th>zirp</th>
      <th>zis</th>
      <th>zitner</th>
      <th>zivalich</th>
      <th>zlinszky</th>
      <th>zmudorz</th>
      <th>znpduvfq</th>
      <th>zo</th>
      <th>zoabi</th>
      <th>zocalo</th>
      <th>zod</th>
      <th>zoellick</th>
      <th>zola</th>
      <th>zollo</th>
      <th>zombie</th>
      <th>zombines</th>
      <th>zondervan</th>
      <th>zone</th>
      <th>zonist</th>
      <th>zonked</th>
      <th>zonta</th>
      <th>zoo</th>
      <th>zook</th>
      <th>zoological</th>
      <th>zoologist</th>
      <th>zoom</th>
      <th>zoomed</th>
      <th>zooming</th>
      <th>zootopia</th>
      <th>zor</th>
      <th>zora</th>
      <th>zranuzsdq</th>
      <th>zubik</th>
      <th>zucker</th>
      <th>zuckerberg</th>
      <th>zuckerman</th>
      <th>zuckerpandian</th>
      <th>zucman</th>
      <th>zuesse</th>
      <th>zulema</th>
      <th>zulia</th>
      <th>zulu</th>
      <th>zurbuchen</th>
      <th>zurich</th>
      <th>zurita</th>
      <th>zuwari</th>
      <th>zwanzig</th>
      <th>zwick</th>
      <th>zwxqtixrl</th>
      <th>zyuganov</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3670</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3671</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3672</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3673</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3674</th>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
<p>3675 rows × 44870 columns</p>
</div>




```python
from wordcloud import WordCloud
```


```python
tfidf_df.aab.unique()
```




    array([0.        , 0.1281378 , 0.07847195, 0.33479442])



# Modeling


```python
from sklearn.pipeline import make_pipeline
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix, ConfusionMatrixDisplay
```


```python
classifiers = [
    ('Naive Bayes', make_pipeline(TfidfVectorizer(), MultinomialNB())),
    ('Logistic Regression', make_pipeline(TfidfVectorizer(), LogisticRegression(max_iter=1000))),
    ('Support Vector Machine', make_pipeline(TfidfVectorizer(), SVC(kernel='linear')))
]

table = PrettyTable(['model', 'accuracy', 'precision', 'recall', 'f1'])

# Iterate over each classifier
for name, text_clf in classifiers:
    score = []
    # Train the classifier
    text_clf.fit(X_train, y_train)

    # Predict on the test set
    predicted = text_clf.predict(X_test)
    
      # Calculate performance metrics
    accuracy = accuracy_score(y_test, predicted)
    precision = precision_score(y_test, predicted, average='weighted')
    recall = recall_score(y_test, predicted, average='weighted')
    f1 = f1_score(y_test, predicted, average='weighted')

    # Add scores to our scores
    score.append(name)
    score.append(accuracy)
    score.append(precision)
    score.append(recall)
    score.append(f1)

    table.add_row(score)

```


```python
print(table)
```

    +------------------------+--------------------+--------------------+--------------------+--------------------+
    |         model          |      accuracy      |     precision      |       recall       |         f1         |
    +------------------------+--------------------+--------------------+--------------------+--------------------+
    |      Naive Bayes       | 0.8411316648531012 | 0.866308814629686  | 0.8411316648531012 | 0.8377685091473562 |
    |  Logistic Regression   | 0.9140369967355821 | 0.9165960673383216 | 0.9140369967355821 | 0.9139871108786369 |
    | Support Vector Machine | 0.9434167573449401 | 0.9437529426911697 | 0.9434167573449401 | 0.943423993739179  |
    +------------------------+--------------------+--------------------+--------------------+--------------------+
    


```python
# Iterate over each classifier
for name, text_clf in classifiers:
    
    text_clf.fit(X_train, y_train)
    # Predict on the test set
    predicted = text_clf.predict(X_test)
    # Output the results
    print(f"{name} Confusion Matrix:")
    
    # Plot the Confusion Matrix
    cm = confusion_matrix(y_test, predicted, labels=text_clf.classes_)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=text_clf.classes_)
    disp.plot()
    plt.show()
    print()
```

    Naive Bayes Confusion Matrix:
    


    
![png](output_52_1.png)
    


    
    Logistic Regression Confusion Matrix:
    


    
![png](output_52_3.png)
    


    
    Support Vector Machine Confusion Matrix:
    


    
![png](output_52_5.png)
    


    
    


```python
classifiers = [
    ('Naive Bayes', MultinomialNB()),
    ('Logistic Regression', LogisticRegression(max_iter=1000)),
    ('Support Vector Machine', SVC(kernel='linear'))
]

table = PrettyTable(['model', 'accuracy', 'precision', 'recall', 'f1'])

# Iterate over each classifier
for name, clf in classifiers:
    scores = [] 
    # Train the classifier
    clf.fit(X_train_tfidf, y_train)

    # Predict on the test set
    predicted = clf.predict(X_test_tfidf)

    # Calculate performance metrics
    accuracy = accuracy_score(y_test, predicted)
    precision = precision_score(y_test, predicted, average='weighted')
    recall = recall_score(y_test, predicted, average='weighted')
    f1 = f1_score(y_test, predicted, average='weighted')

    # Add scores to our scores
    scores.append(name)
    scores.append(accuracy)
    scores.append(precision)
    scores.append(recall)
    scores.append(f1)

    table.add_row(scores)
```


```python
print(table)
```

    +------------------------+--------------------+--------------------+--------------------+--------------------+
    |         model          |      accuracy      |     precision      |       recall       |         f1         |
    +------------------------+--------------------+--------------------+--------------------+--------------------+
    |      Naive Bayes       | 0.8411316648531012 | 0.866308814629686  | 0.8411316648531012 | 0.8377685091473562 |
    |  Logistic Regression   | 0.9140369967355821 | 0.9165960673383216 | 0.9140369967355821 | 0.9139871108786369 |
    | Support Vector Machine | 0.9434167573449401 | 0.9437529426911697 | 0.9434167573449401 | 0.943423993739179  |
    +------------------------+--------------------+--------------------+--------------------+--------------------+
    


```python
# Iterate over each classifier
for name, clf in classifiers:
    
    clf.fit(X_train_tfidf, y_train)
    # Predict on the test set
    predicted = clf.predict(X_test_tfidf)
    # Output the results
    print(f"{name} Confusion Matrix:")
    
    # Plot the Confusion Matrix
    cm = confusion_matrix(y_test, predicted, labels=clf.classes_)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=clf.classes_)
    disp.plot()
    plt.show()
    print()
```

    Naive Bayes Confusion Matrix:
    


    
![png](output_55_1.png)
    


    
    Logistic Regression Confusion Matrix:
    


    
![png](output_55_3.png)
    


    
    Support Vector Machine Confusion Matrix:
    


    
![png](output_55_5.png)
    


    
    
